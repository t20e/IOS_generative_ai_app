import { ObjectId } from 'mongodb';
import UserModel from "../models/user.model.js"
import bcrypt from "bcrypt"
import jwt from 'jsonwebtoken';

export default class UserController {
    constructor(buildRequestReturnData, AWS, SECRET_KEY) {
        this.userModel = UserModel
        this.AWS = AWS
        this.SECRET_KEY = SECRET_KEY
        this.buildRequestReturnData = buildRequestReturnData
    }

    signJwtToken = (user) => {
        return {
            "name": "userToken",
            "cookie":
                jwt.sign(
                    {
                        _id: user._id,
                        firstName: user.firstName,
                        lastName: user.lastName,
                    },
                    this.SECRET_KEY,
                    { expiresIn: '5d' }
                )
        }
    }

    authenticateUser = (req, res, next) => {
        jwt.verify(req.headers.authorization, this.SECRET_KEY, (err, payload) => {
            // err ? (res.status(401).json({ authenticatedUser: false }), console.log("Unauthorized cookie", err)) : next();
            if (err) {
                res.status(401).json({ authenticatedUser: false })
                console.log("Unauthorized cookie", err)    
            }
            const decodedJWT = jwt.decode(req.headers.authorization, { complete: true })
            req.body.userId = decodedJWT.payload._id
            next()
        });
    }


    reg_check_if_email_exists = async (req, res, next) => {
        /*
            when user if attempting to register this will validate and check if the email address is already in user
        */

        const emailRegex = /^([\w-\.]+@([\w-]+\.)+[\w-]+)?$/
        const isValidEmail = await emailRegex.test(req.body.email)
        console.log("IS it a valid EMAIL?==>", isValidEmail)
        if (isValidEmail === false) {
            console.log("User entered invalid email!")
            res.status(422).json("Please enter a valid email address"); return
        }
        try {
            const emailCheck = await this.userModel.find({ email: req.body.email }) //returns an array of items
            if (emailCheck.length === 0) {
                console.log("Email not in use yet")
                req.body.returnData = this.buildRequestReturnData(202, "Email not in use", { "doesEmailAlreadyExist": false })
            } else {
                console.log("Email already exists")
                req.body.returnData = this.buildRequestReturnData(409, "Email is already in use", { "doesEmailAlreadyExist": true })
            }
            next()
        } catch (err) {
            console.log("Error checking if email is registered", err)
            return res.status(500).json({ msg: "Error checking if email is registered" })
        }
    }

    register = async (req, res, next) => {
        const checkEmail = await this.userModel.findOne({ email: req.body.email })
        // console.log('user', checkEmail)
        if (checkEmail !== null) {
            return res.status(409).json({ msg: "Email already exists" })
        }
        try {
            console.log("Register new User")
            const newUser = await this.userModel.create(req.body)
            // turn the newUser document into a plain js object
            let user = newUser.toObject()
            delete user.password
            req.body.returnData = this.buildRequestReturnData(201, "Successfully registered user", user)
            req.hasCookie = this.signJwtToken(user)
            next()
        } catch (error) {
            console.log("err registering user, err:", error)
            return res.status(500).json({ msg: "err registering user" })
        }
    }

    login = async (req, res, next) => {
        console.log(req.body)
        console.log(typeof (req.body))
        // the .lean() allows me to be able to use the delete keyword to delete certain fields form the user like password before sending to frontend
        const user = await this.userModel.findOne({ email: req.body.email }).lean()
        // console.log('user', user)
        if (user === null) {
            console.log("User not found")
            return res.status(401).json({ msg: "Wrong Credentials" })
        }
        bcrypt.compare(req.body.password, user.password)
            .then(async passwordCheck => {
                if (passwordCheck) {
                    delete user.password
                    if (user.generatedImgs.length > 0){
                        user.generatedImgs = await this.AWS.getManyObjectsPresignedUrl(user.generatedImgs)
                    }
                    req.body.returnData = this.buildRequestReturnData(200, "Successfully login user", user)
                    req.hasCookie = this.signJwtToken(user)
                } else {
                    req.body.returnData = this.buildRequestReturnData(401, "Unauthorized login attempt", "")
                }
                next()
            })
            .catch(err => {
                console.log("Error Logging in user", err)
                res.status(500).json({ "msg": "error logging in user" })
            });
    }

    lastUserRequestMiddleware = (req, res) => {
        /*
            the last middleware that redirects the request back to the frontend for user specific requests
            parameters:
                needs msg, returnStatusCode and returnData in req.body from previous middlewares
            returns: 
                req.body.returnStatusCode
                {
                    // issue with parsing user to struct on frontend so i dont send a msg"msg" : req.body.msg : 
                    "data" : req.body.data
                }
        */
        try {
            if (req.hasCookie) {
                return res
                    .cookie(req.hasCookie.name, req.hasCookie.cookie, { httpOnly: true })
                    .status(req.body.returnData.statusCode)
                    .json({
                        "msg": req.body.returnData.msg,
                        "data": req.body.returnData.data
                    })
            }
            res
                .status(req.body.returnData.statusCode)
                .json({
                    "msg": req.body.returnData.msg,
                    "data": req.body.returnData.data
                })
        } catch (err) {
            console.log("Error returning users request, err:", err)
            res.status(500).json({ "msg": "Error returning users request" })
        }
    }

    addImgKeyToUser = async (req, res) => {
        /*
            parameters:
                need img_id, prompt in req.body
            returns:
                img_id, and prompt, presigned_url the user on the front end will use the url to get the image
                from frontend
        */
        const obj = {
            "img_id": req.body.img_id,
            "prompt": req.body.prompt
        }
        try {
            let addImg = await this.userModel.updateOne(
                {_id: new ObjectId(req.body.userId)},
                { $push: { generatedImgs: obj } }
            )
            obj.presigned_url = await this.AWS.getPreSignedUrl(req.body.img_id)
            const returnData = this.buildRequestReturnData(201, obj)
            res.status(201).json({ "msg": "Successfully Generated Image", "data": returnData })
        } catch (err) {
            console.log('Error add image id to user, ERR:', err)
            return res.status(500).send("Error add image id to user")
        }
    }


    getLoggedUser = async (req, res, next) => {
        console.log("Attempting to log user in from token...")
        const decodedJWT = jwt.decode(req.headers.authorization, { complete: true })
        if (decodedJWT !== null) {
            this.userModel.findOne({ _id: decodedJWT.payload._id }).lean()
                .then(async user => {
                    console.log("User's token is good, and found user")
                    delete user.password
                    if (user.generatedImgs.length > 0){
                        user.generatedImgs = await this.AWS.getManyObjectsPresignedUrl(user.generatedImgs)
                    }
                    req.body.returnData = this.buildRequestReturnData(200, "Successfully got logged in user", user)
                    next()
                })
                .catch(err => {
                    console.log("error getting logged in user", err)
                    req.body.returnData = this.buildRequestReturnData(500, "Internal server error please try again later", { 'err' : "serverError" })
                })
        } else {
            console.log("User token either expired or error occurred")
            res
                .status(401)
                .json({ 'notAuthenticated': 'Your token has expired' })
        }
    }
}


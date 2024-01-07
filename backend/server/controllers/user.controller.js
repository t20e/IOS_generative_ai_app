import { ObjectId } from 'mongodb';
import UserModel from "../models/user.model.js"
import bcrypt from "bcrypt"
import jwt from 'jsonwebtoken';
import { generateUnique6DigitNumber } from "../utils/utils.js"


export default class UserController {
    constructor(buildRequestReturnData, AWS, SECRET_KEY, ALLOWED_FREE_NUM_OF_GENERATED_IMGS) {
        /*
            Parameters:
                buildRequestReturnData : build request return data
                SECRET_KEY used for signing JWT tokens
                verificationCodes: stores the email and verification code when user is verifying their email
        */


        this.userModel = UserModel
        this.AWS = AWS
        this.SECRET_KEY = SECRET_KEY
        this.buildRequestReturnData = buildRequestReturnData
        this.verificationCodes = new Map()
        this.ALLOWED_FREE_NUM_OF_GENERATED_IMGS = ALLOWED_FREE_NUM_OF_GENERATED_IMGS
    }

    signJwtToken = (user) => {
        return jwt.sign(
            {
                _id: user._id,
                firstName: user.firstName,
                lastName: user.lastName,
            },
            this.SECRET_KEY,
            { expiresIn: '5d' }
        )
    }

    authenticateUser = (req, res, next) => {
        jwt.verify(req.headers.authorization, this.SECRET_KEY, (err, payload) => {
            // err ? (res.status(401).json({ authenticatedUser: false }), console.log("Unauthorized token", err)) : next();
            if (err) {
                res.status(401).json({ authenticatedUser: false })
                console.log("Unauthorized token", err)
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
        console.log("Is users email valid? ==>", isValidEmail)
        if (isValidEmail === false || req.body.email.length < 5) {
            console.log("User entered invalid email!")
            res.status(422).json("Please enter a valid email address"); return
        }
        try {
            const emailCheck = await this.userModel.find({ email: req.body.email }) //returns an array of items
            if (emailCheck.length === 0) {
                console.log("Email not in use yet")
                const code = generateUnique6DigitNumber()
                this.verificationCodes.set(req.body.email, code)
                console.log("CODE: " + code)
                // TODO send code to email from form aws

                req.body.returnData = this.buildRequestReturnData(202, "A code has been sent to your email please enter it.", { "doesEmailAlreadyExist": false })
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
        // make sure that the email is in vertitficationCode so we know that the user went through that process and isn't trying to jump to register

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
            user.accessToken = this.signJwtToken(user)
            req.body.returnData = this.buildRequestReturnData(201, "Successfully registered user", user)
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
                    console.log("User found when logging in")
                    delete user.password
                    if (user.generatedImgs.length > 0) {
                        user.generatedImgs = await this.AWS.getManyObjectsPresignedUrl(user.generatedImgs)
                    }
                    user.accessToken = this.signJwtToken(user)
                    req.body.returnData = this.buildRequestReturnData(200, "Successfully login user", user)
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

    addImgKeyToUser = async (req, res, next) => {
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
                { _id: new ObjectId(req.body.userId) },
                {
                    $push: { generatedImgs: obj },
                    $inc: { numOfImgsGenerated: 1 } //increment the field by 1
                },
            )
            obj.presigned_url = await this.AWS.getPreSignedUrl(req.body.img_id)
            req.body.returnData = this.buildRequestReturnData(201, "Successfully generated image", obj)
            // res.status(201).json({ "msg": "Successfully Generated Image", "data": returnData })
            next()
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
                    if (user.generatedImgs.length > 0) {
                        user.generatedImgs = await this.AWS.getManyObjectsPresignedUrl(user.generatedImgs)
                    }
                    req.body.returnData = this.buildRequestReturnData(200, "Successfully got logged in user", user)
                    next()
                })
                .catch(err => {
                    console.log("error getting logged in user", err)
                    req.body.returnData = this.buildRequestReturnData(500, "Internal server error please try again later", { 'err': "serverError" })
                    next()
                })
        } else {
            console.log("User token either expired or error occurred")
            res
                .status(401)
                .json({ 'notAuthenticated': 'Your token has expired' })
        }
    }

    contactUs = async (req, res, next) => {
        console.log(req.body)
        // users id is already in the req.body
        // TODO figure out what to do with the users issue use aws to send issue to myself
        req.body.returnData = this.buildRequestReturnData(200, "Issue Received", { "success": true })
        next()
    }

    verifyCode = async (req, res, next) => {
        console.log(req.body)
        const inputCode = Number(req.body.code.trimRight())

        const storedCode = this.verificationCodes.get(req.body.email)
        console.log(this.verificationCodes)

        if (storedCode === undefined || storedCode !== inputCode) {
            console.log("Email not know please try again later.")
            req.body.returnData = this.buildRequestReturnData(400, "Email not know please try again later.", { "success": false })
        } else if (storedCode === inputCode) {
            console.log("Entered correct code.")
            this.verificationCodes.delete(req.body.email)
            req.body.returnData = this.buildRequestReturnData(200, "Email verified", { "success": true })
        } else {
            req.body.returnData = this.buildRequestReturnData(500, "Server error try again later.", { "success": false })
        }
        next()
    }

    sendCodeToEmail = (req, res, next) => {
        // used to send code to users email address 
        const code = generateUnique6DigitNumber()
        this.verificationCodes.set(req.body.email, code)
        console.log("CODE:", code)
        // TODO send code to email from aws
        req.body.returnData = this.buildRequestReturnData(200, "Code sent to your email", { "success": true })
        next()
    }

    changePassword = async (req, res, next) => {
        // grab the new password the email and the code from req.body
        const inputCode = Number(req.body.code.trimRight())
        const storedCode = this.verificationCodes.get(req.body.email)
        console.log(this.verificationCodes)
        if (storedCode === undefined) {
            console.log("Email not know please try again later.")
            req.body.returnData = this.buildRequestReturnData(400, "Email not know please try again later.", { "success": false })
        } else if (storedCode === inputCode) {
            console.log("Entered correct code.")
            // the code they entered is correct update the users password
            const hashedPass = await bcrypt.hash(req.body.newPassword, 10)
            const result = await this.userModel.updateOne(
                { email: req.body.email },
                { $set: { password: hashedPass } }
            );
            if (result.matchedCount === 1) {
                console.log(`Password changed successfully`);
                this.verificationCodes.delete(req.body.email)
                req.body.returnData = this.buildRequestReturnData(200, "Password changed", { "success": true })
            } else {
                req.body.returnData = this.buildRequestReturnData(401, "Please check your credentials", { "success": false })
            }
        } else {
            req.body.returnData = this.buildRequestReturnData(400, "Wrong code.", { "success": false })
        }
        next()
    }

    deleteAccount = async (req, res, next) => {
        const user = await this.userModel.findOne({ email: req.body.email }).lean()
        // console.log('user', user)
        if (user === null) {
            console.log("User not found")
            return res.status(401).json({ msg: "Wrong Credentials" })
        }
        let passwordCheck = await bcrypt.compare(req.body.password, user.password)
        if (passwordCheck) {
            let resultDeleteAllImgs = await this.AWS.deleteManyImgs(user.generatedImgs)
            if (resultDeleteAllImgs) {
                console.log("Successfully deleted account")
                req.body.returnData = this.buildRequestReturnData(200, "Successfully deleted account", { "success": true })
                const deleteAccount = await this.userModel.deleteOne({ _id: user._id })
                console.log(deleteAccount)
            } else {
                req.body.returnData = this.buildRequestReturnData(500, "Issue deleting images, please try later", { "success": false })
            }
        } else {
            req.body.returnData = this.buildRequestReturnData(401, "Failed deleting account", { "success": false })
        }
        next()
    }

    canUserGenerateImg = async (req, res, next) => {
        console.log("Checking if user can generate a free image...")
        const decodedJWT = jwt.decode(req.headers.authorization, { complete: true })
        if (decodedJWT !== null) {
            const user = await this.userModel.findOne({ _id: decodedJWT.payload._id })
            if (user.numOfImgsGenerated <= this.ALLOWED_FREE_NUM_OF_GENERATED_IMGS) {
                next()
                return
            }
        }
        res.status(402).send(`Sorry you can't generate more than ${this.ALLOWED_FREE_NUM_OF_GENERATED_IMGS} free images`)
    }
}

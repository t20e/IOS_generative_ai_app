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


    checkIfEmailExists = async (req, res, next) => {
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
                const result = await this.AWS.sendEmail(req.body.email, "", "", code, false, "")
                if (result.err) {
                    res.status(500).send(`Sorry there was an issue, please try later.`)
                    return
                }
                req.body.returnData = this.buildRequestReturnData(202, "A code has been sent to your email please enter it.", { "doesEmailAlreadyExist": false })
                next()
            } else {
                console.log("Email already exists")
                req.body.returnData = this.buildRequestReturnData(409, "Email is already in use", { "doesEmailAlreadyExist": true })
            }
            next() // move to the sendEmail
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
        if (req.body.newPassword != ""){
            console.log("resetting password")
            // verify the code that was sent to the users email
            const inputCode = Number(req.body.code.trimRight())
            const storedCode = this.verificationCodes.get(req.body.email)
            const verify = this.verifyCode(req.body, storedCode, inputCode)
            if (verify.statusCode === 200){
                const user = await this.userModel.findOne({ email: req.body.email }).lean()
                // the code they entered is correct update the users password
                const hashedPass = await bcrypt.hash(req.body.newPassword, 10)
                const result = await this.userModel.updateOne(
                    { email: req.body.email },
                    { $set: { password: hashedPass } }
                );
                if (result.matchedCount === 1) {
                    console.log(`Password changed successfully`);
                    delete user.password
                    if (user.generatedImgs.length > 0) {
                        user.generatedImgs = await this.AWS.getManyObjectsPresignedUrl(user.generatedImgs)
                    }
                    user.accessToken = this.signJwtToken(user)
                    req.body.returnData = this.buildRequestReturnData(200, "Successfully login user", user)
                } else {
                    console.log("Wrong credentials")
                    req.body.returnData = this.buildRequestReturnData(401, "Please check your credentials", { "success": false })
                }
                next()
            }else{
                // if the code is not right
                req.body.returnData = verify
                next()
            }
        }else{
            // do normal login
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
                    $inc: { numImgsGenerated: 1 } //increment the field by 1
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

    capitalizeFirstLetter(word) {
        return word.charAt(0).toUpperCase() + word.slice(1);
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

    getCodeToEmail = async (req, res, next) => {
        // this is for when the user attempts to change password or delete account NOT for validating email
        console.log(req.body)

        // find the user in mongodb
        const user = await this.userModel.findOne({ email: req.body.email }).lean()
        if (user === null) {
            console.log("User not found")
            return res.status(401).json({ msg: "Wrong Credentials" })
        }
        const code = generateUnique6DigitNumber()
        this.verificationCodes.set(req.body.email, code)
        console.log("CODE: " + code)
        let firstNameCapitalized = this.capitalizeFirstLetter(req.body.firstName)
        const result = await this.AWS.sendEmail(req.body.email, firstNameCapitalized, "", code, false, "")
        if (result.err) {
            res.status(500).send(`Sorry there was an issue sending a code to your email, please try later.`)
            return
        }
        req.body.returnData = this.buildRequestReturnData(200, "A code has been sent to your email please enter it.", { "doesEmailAlreadyExist": false })
        next()
    }

    contactUs = async (req, res, next) => {
        // console.log("contact us body",req.body)
        // users id is already in the req.body
        let firstNameCapitalized = this.capitalizeFirstLetter(req.body.firstName)
        const result = await this.AWS.sendEmail(req.body.email, firstNameCapitalized, req.body.userId, "", true, req.body.issue)

        if (result.err) {
            res.status(500).send(`Sorry was an issue contacting us, please try later.`)
            return
        }
        req.body.returnData = this.buildRequestReturnData(200, "Issue received, we will get back to you shortly.", { "success": true })
        next()
    }

    verifyEmail = async (req, res, next) => {
        console.log(req.body)
        const inputCode = Number(req.body.code.trimRight())
        const storedCode = this.verificationCodes.get(req.body.email)
        console.log(this.verificationCodes)
        req.body.returnData = this.verifyCode(req.body, storedCode, inputCode)
        next()
    }

    verifyCode = (body, storedCode, inputCode) =>{
        if (storedCode === undefined || storedCode !== inputCode) {
            console.log("Wrong credentials, wrong code: ")
            return this.buildRequestReturnData(401, "Credentials are wrong", { "success": false })
        } else if (storedCode === inputCode) {
            console.log("Entered correct code.")
            this.verificationCodes.delete(body.email)
            return this.buildRequestReturnData(200, "Email verified", { "success": true })
        } else {
            return this.buildRequestReturnData(500, "Server error try again later.", { "success": false })
        }
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
        const user = await this.userModel.findOne({ email: req.body.email })
        // console.log('user', user)
        if (user === null) {
            console.log("User not found")
            return res.status(401).json({ msg: "Wrong Credentials" })
        }
        let passwordCheck = await bcrypt.compare(req.body.password, user.password)
        if (passwordCheck) {
                let resultDeleteAllImgs = await this.AWS.deleteManyImgs(user.generatedImgs)
                if (resultDeleteAllImgs) {
                    const deleteAccount = await this.userModel.deleteOne({ _id: user._id })
                    console.log("Successfully deleted account")
                    req.body.returnData = this.buildRequestReturnData(200, "Successfully deleted account", { "success": true })
                } else{
                    return res.status(500).json({ msg: "Issue deleting account, please try later or contact us!" })
                }
        } else {
            return res.status(401).json({ msg: "Wrong Credentials" })
        }
        next()
    }

    canUserGenerateImg = async (req, res, next) => {
        console.log("Checking if user can generate a free image...")
        const decodedJWT = jwt.decode(req.headers.authorization, { complete: true })
        if (decodedJWT !== null) {
            const user = await this.userModel.findOne({ _id: decodedJWT.payload._id })
            if (user.numImgsGenerated < this.ALLOWED_FREE_NUM_OF_GENERATED_IMGS) {
                next()
                return
            }
        }
        console.log("User has generated the maximum amount of images")
        res.status(402).send(`Sorry you can't generate more than ${this.ALLOWED_FREE_NUM_OF_GENERATED_IMGS} free images`)
    }



}

// const jwt = require('jsonwebtoken');
// const ObjectId = require('mongodb').ObjectId;
import { ObjectId } from 'mongodb';
const obj_id = new ObjectId();

// const randomstring = require("randomstring");

// const { getSignedUrl } = require("@aws-sdk/s3-request-presigner");
// const chatController = require("./chat.controller");
// const { response } = require("express");

import UserModel from "../models/user.model.js"
import bcrypt from "bcrypt"

export default class UserController {
    constructor() {
        this.userModel = UserModel
    }
    check_if_email_exists = async (req, res) => {
        const emailCheck = await this.userModel.find({ email: req.body.email }) //returns an array of items
        if (emailCheck.length === 0) {
            return res.status(200).json({ msg: { "doesEmailAlreadyExist": false } })
        }
        console.log("Email already exists")
        return res.status(409).json({ msg: { "doesEmailAlreadyExist": true } })
    }

    register = async (req, res) => {
        const checkEmail = await this.userModel.findOne({ email: req.body.email })
        // console.log('user', checkEmail)
        if (checkEmail !== null) {
            return res.status(409).json({ msg: "Email already exists" })
        }
        try {
            //create a new user
            console.log("Register new User")
            const newUser = await this.userModel.create(req.body)
            // TODO figure out what to do with swifts frontend tokens sessions etc
            res.status(201).json({ msg: "Successfully registered user" })
        } catch (error) {
            console.log("err registering user, err:", error)
            return res.status(500).json({ msg: "err registering user", err: error })
        }
    }

    login = async (req, res) => {
        const user = await this.userModel.findOne({ email: req.body.email })
        // console.log('user', user)
        if (user === null) {
            return res.status(404).json({ msg: "User not found" })
        }
        bcrypt.compare(req.body.password, user.password)
            .then(passwordCheck => {
                if (passwordCheck) {
                    res.
                        status(200)
                        // .cookie("userToken", jwt.sign({
                        //     _id: user._id,
                        //     firstName: user.firstName,
                        //     lastName: user.lastName
                        // }, process.env.SECRET_KEY), { httpOnly: true })
                        .json({ msg: 'successfully logged in', 'user': user })
                } else {
                    res.
                        status(401)
                        .json({
                            msg: 'Unauthorized login attempt'
                        })
                }
            })
            .catch(err => {
                res.status(500).json({ "msg": "error logging in user" })
            });
    }


    authenticateUser(req, res, next) {
        // TODO authenticate user not sure from what yet
        console.log('\n AuthenticateUser')
        next()
    }

    async addImgToUser(req, res) {
        // add img id to user this
        // TODO add try catch
        try {
            console.log(this.userModel)
        } catch (error) {
            console.log('err userModel not defined', error)
        }
        // let addImg = await this.userModel.update(
        //     { _id: obj_id("657bf679a39ba1481923045a") },
        //     { $push: { generated_imgs_ids: req.body.image_id } }
        // )
        // console.log("result from adding image to user: " + addImg)

        // TODO send image data to frontend
        res.send(req.body.image_id)
    }

    // getLoggedUser = (req, res) => {
    //     const decodedJWT = jwt.decode(req.cookies.userToken, { complete: true })
    //     // console.log("cookie user is:", decodedJWT.payload._id);
    //     if (decodedJWT !== null) {
    //         User.findOne({ _id: decodedJWT.payload._id })
    //             .then(user => {
    //                 res.json({ results: user })
    //             })
    //             .catch(err => {
    //                 res.json(err)
    //             })
    //     } else {
    //         res.json({ 'err': 'getting loaded user from payload' })
    //     }
    // }

    logout = (req, res) => {
        res.clearCookie('userToken');
        res.sendStatus(200);
    }
}


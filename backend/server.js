import express from 'express';
import http from 'http';
import https from 'https';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import dotenv from 'dotenv';
import connectToMongodb from "./server/config/mongoose.config.js";
import userRoutes from './server/routes/user.routes.js'
import UserController from './server/controllers/user.controller.js'
import imgRoutes from './server/routes/img.routes.js'
import OpenAI_Controller from "./server/controllers/openAI_API.controller.js"
import AWS from './server/config/aws_cli.config.js';

dotenv.config();

class Server {
    constructor() {
        this.PORT = process.env.PORT;
        this.IN_PROD = process.env.IN_PROD.toLowerCase() === "true"
        this.app = express();
        this.AWS = new AWS(process.env.BUCKET_NAME, process.env.BUCKET_REGION, process.env.ACCESS_KEY_AWS_USER, process.env.SECRET_ACCESS_KEY_AWS_USER)
        this.userCon = new UserController(this.buildRequestReturnData, this.AWS, process.env.SECRET_KEY)
        this.openai_api = new OpenAI_Controller(process.env.OPENAI_API_SECRET_KEY, this.AWS)

        this.setUpMiddleware()
        this.setUpRoutes()
    }

    setUpMiddleware() {
        this.app.use(express.json()); //parse the JSON data so that post req.body data isn't empty {} JSON middleware only works if the request has Content-Type: application/json header.

        // this.app.use(express.urlencoded({ extended: true }));
        this.app.use(cors({ credentials: true, origin: this.url }));
        this.app.use(cookieParser());
        // this.session = session({
        //     secret: process.env.SECRET_KEY,
        //     cookie: {
        //         sameSite: "strict",
        //         maxAge: 21600000
        //     },
        //     resave: false,
        //     saveUninitialized: false,
        // })

        if (this.IN_PROD === true) {
            console.log('Mode is production')
            this.app.set("trust proxy", 1); // trust first proxy
            // Please note that secure: true is a recommended option. However, it requires an https-enabled website, i.e., HTTPS
            // this.session.cookie.secure = true; // serve secure cookies
            this.http_server = https.createServer(this.app);
        } else {
            this.http_server = http.createServer(this.app);
        }
        connectToMongodb(process.env.MONGODB_USER_NAME, process.env.MONGODB_PASSWORD)
    }

    setUpRoutes() {
        userRoutes(this.app, this.userCon)
        imgRoutes(this.app, this.openai_api, this.userCon, this.AWS)

        this.app.post("/api/v1/test", (req, res) => {
            console.log("body: ==>", req.body)
            res.send("hello world!");
        })

        // this.app.get('/*', user.authenticateUser, (req, res) => {
        this.app.get('/*', (req, res) => {
            res.status(404).send("404 not found");
        });
    }

    // TODO FIX ALL THE CALLSE IT SHOULD ONLY BE STATUS code and data not msg
    buildRequestReturnData(returnStatusCode, data) {
        /*
            builds the return data for user specific requests
            return: obj
        */
        return {
            data,
            "statusCode": returnStatusCode
        }
    }

    start() {
        this.http_server.listen(this.PORT, () => {
            console.log(`Server listening on port: ${this.PORT}`);
        });
    }
}


const server = new Server();

server.start()


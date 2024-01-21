
import { getSignedUrl } from "@aws-sdk/s3-request-presigner"
import { S3Client, GetObjectCommand, PutObjectCommand, DeleteObjectCommand, DeleteObjectsCommand } from "@aws-sdk/client-s3";
import axios from "axios";
import { SESClient, CreateConfigurationSetCommand } from "@aws-sdk/client-ses";
import { SendEmailCommand } from "@aws-sdk/client-ses";


class AWS {
    constructor(BUCKET_NAME, BUCKET_REGION, ACCESS_KEY_AWS_USER, SECRET_ACCESS_KEY_AWS_USER, DOMAIN, EMAIL_ADDRESS) {
        this.s3 = this.setUpS3(...arguments)//pass all the parameters
        this.bucket_name = BUCKET_NAME
        this.sesClient = this.setUpSES(...arguments)
        this.DOMAIN = DOMAIN
        this.EMAIL_ADDRESS = EMAIL_ADDRESS
    }

    setUpS3(bucket_name, bucket_region, access_key_aws_user, secret_access_key_aws_user) {
        // // configure s3 bucket
        const s3 = new S3Client({
            credentials: {
                accessKeyId: access_key_aws_user,
                secretAccessKey: secret_access_key_aws_user,
            },
            region: bucket_region,
        })
        return s3
    }

    setUpSES(bucket_name, bucket_region, access_key_aws_user, secret_access_key_aws_user) {
        const sesClient = new SESClient({
            credentials: {
                accessKeyId: access_key_aws_user,
                secretAccessKey: secret_access_key_aws_user,
            },
            region: bucket_region,
        });
        return sesClient
    }

    getPreSignedUrl = async (key) => {
        /*
            parameters:
                the objects key to identify it, don't include file extension
            returns:
                a presigned url that can be used to access s3 bucket images
        */
        const command = new GetObjectCommand({
            Bucket: this.bucket_name,
            Key: `users_imgs/${key}.png`
        });
        const url = await getSignedUrl(this.s3, command, { expiresIn: 302400 }); // 3 and a half days
        // console.log("URL: " + url);
        return url
    }

    getManyObjectsPresignedUrl = async (generatedImgs) => {
        /*
            parameters:
                array of objs: of users generated images that has img_id, and prompt
            returns:
                obj: with presigned url for each image
        */
        try {
            await Promise.all(generatedImgs.map(async (e) => {
                e["presigned_url"] = await this.getPreSignedUrl(e["img_id"]);
            }));
            // console.log(req.body.generatedImgs)
            // res.json(req.body.generatedImgs)
            return generatedImgs
        } catch (error) {
            print("Error get many objects for user: " + error.message)
            return []
        }
    }

    deleteManyImgs = async (generatedImgs) => {
        /*
        Bulk delete all users images when user is deleting account
        parameters:
            array of objs: of users generated images that has img_id, and prompt
        returns:
            Bool : if successful or not
        */
        if (generatedImgs.length === 0){
            //user has no images return no error
            return true
        }

        let imgsToBeDeleted = [] // stored as [{"key" : `${obj.img_id}.png`]
        generatedImgs.forEach(obj => {
            imgsToBeDeleted.push({ "Key": `users_imgs/${obj.img_id}.png` })
        });
        console.log(imgsToBeDeleted)
        const command = new DeleteObjectsCommand({
            Bucket: this.bucket_name,
            Delete: {
                Objects: imgsToBeDeleted
            }
        })
        try {
            const { Deleted } = await this.s3.send(command);
            console.log(
                `Successfully deleted ${Deleted.length} objects from S3 bucket. Deleted objects:`,
            );
            console.log(Deleted.map((d) => ` • ${d.Key}`).join("\n"));
            return true
        } catch (err) {
            console.error(err);
            return false
        }

    }


    downloadImgFromUrl = async (req, res, next) => {
        /*
            To download from openAI so that i can save the image to S3
            parameters:
                needs img_url in req.body
            returns:
                imgData in the req.body object
        */
        try {
            const url = req.body.img_url
            const img_res = await axios({
                'url': url,
                'method': 'get',
                'responseType': 'arraybuffer'
            })
            // console.log(img_res.data)
            // return res.send("hello")
            req.body.imgData = img_res.data
            next()
        } catch (err) {
            console.log("Error downloading image from url, Err:", err)
            return res.status(500).send("Error downloading image from url")
        }
    }

    uploadToS3 = async (req, res, next) => {
        /*
            upload to s3 bucket
            parameters:
                needs img_id and imgData in the req.body
        */
        const img_id = req.body.img_id
        const imgData = req.body.imgData
        try {
            const command = new PutObjectCommand({
                Bucket: this.bucket_name,
                Key: `users_imgs/${img_id}.png`,
                Body: imgData,
                ContentType: 'image/png' //imgData.headers["content-type"],
            });
            await this.s3.send(command)
            next()
        } catch (err) {
            console.log("Error uploading image, Err:", err)
            return res.status(500).send("Error uploading image to s3")
        }
    }

    sendEmail = async (recipientEmail, usersName, userId, code, sendToGenta, supportIssue) => {
        /*
        Parameters:
            email: String : what email to send mail to
            toContactUs: Boolean | whether to send the email to contact us or send to users email
        */
        let template = this.getTemplate(recipientEmail, usersName, userId, code, sendToGenta, supportIssue)
        var command = new SendEmailCommand({
            Source: this.DOMAIN,
            Destination: {
                ToAddresses: [
                    sendToGenta ? this.EMAIL_ADDRESS : recipientEmail
                ],
            },
            ReplyToAddresses: [],
            Message: {
                /* required */
                Body: {
                    Html: {
                        Charset: "UTF-8",
                        Data: template,
                    },
                    Text: {
                        // the is only if it has trouble sending the html it will default to the text
                        Charset: "UTF-8",
                        Data: `Hey, ${usersName}, sorry their was an issue sending data to your email, enter this code in the app code: ${code}`,
                    },
                },
                // subject sent to user
                Subject: {
                    Charset: "UTF-8",
                    Data: "genTa App Verification Code",
                },
            },
        })

        try {
            const res = await this.sesClient.send(command)
            console.log("email sent successfully, res:")
            return { err: false }
        } catch (error) {
            console.log("Error sending email: " + error.message)
            return { err: true }
        }
    }

    getTemplate(recipientEmail, usersName, userId, code, sendToGenta, supportIssue) {
        if (sendToGenta){
            return `
                <h1>Users support request</h1>
                <h3>Users info</h3>
                <p>
                UserId: ${userId}
                <br>
                Name: ${usersName}
                <br>
                Email: ${recipientEmail}
                <br>
                </p>
                <p>
                Issue, please review: <br>
                <br>
                ${supportIssue}
                </p>
            `
        } else {
            //send to the user
            return  `
            <Section style="
            margin: 0;
            padding: 0;  
            padding:5em ;
            background: linear-gradient(180deg,rgb(255,155,66) 0%, rgb(239,233,244) 35%, rgb(22,186,197) 100%);">
            <section style="text-align: center;
            background-color: #EFE9F4; 
            border-radius: 10px;
            padding: 20px 40px; 
            box-shadow: rgba(100, 100, 111, 0.2) 0px 7px 29px 0px;
            /* height: 22em; */
            /* width: 22em; */
            max-width: 25em;
            max-height: 25em;
            margin: 0 auto;
            font-family: Arial, Helvetica, sans-serif;
        ">
            <header>
                <img style="height: 80px; width: 80px; border-radius: 20px;" src="https://s3-bucket-public-for-all-project.s3.amazonaws.com/genta-app/appIcon.png" alt="app icon" srcset="">
                <p style="font-weight: bold;color: #000;">genTa app</p>
            </header>
            <Section>
                <h3 style="color: #333; font-family: Arial, sans-serif; font-size: 24px; text-align: center;">Hey, ${usersName}</h3>
                <p style="color: #555;  text-align: center; font-size: 1.5em">Please enter this code in the app.</p>
                <Section style=" background-color: #16BAC5; color: white; border-radius: 20px; padding-left: 20px; padding-right: 20px; ">                    
                    <h1 style="margin: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 4em; letter-spacing: 10px;  margin-right:-10px;">${code}</h1>
                </Section>
            </Section>
        </Section>
            `
        }
    }
}

export default AWS
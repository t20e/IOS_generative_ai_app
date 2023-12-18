
import { getSignedUrl } from "@aws-sdk/s3-request-presigner"
import { S3Client, GetObjectCommand, PutObjectCommand, DeleteObjectCommand } from "@aws-sdk/client-s3";
import axios from "axios";

class AWS {
    constructor(BUCKET_NAME, BUCKET_REGION, ACCESS_KEY_AWS_USER, SECRET_ACCESS_KEY_AWS_USER) {
        this.s3 = this.setUpS3(...arguments)//pass all the parameters
        this.bucket_name = BUCKET_NAME
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
        const url = await getSignedUrl(this.s3, command, { expiresIn: 10800 });
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
        await Promise.all(generatedImgs.map(async (e) => {
            e["presigned_url"] = await this.getPreSignedUrl(e["img_id"]);
        }));
        // console.log(req.body.generatedImgs)
        // res.json(req.body.generatedImgs)
        return generatedImgs
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

}

export default AWS
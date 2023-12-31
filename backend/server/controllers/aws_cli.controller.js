
import { getSignedUrl } from "@aws-sdk/s3-request-presigner"
import { S3Client, GetObjectCommand, PutObjectCommand, DeleteObjectCommand, DeleteObjectsCommand } from "@aws-sdk/client-s3";
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
        Bulk delets all users images when user is deleting account
        parameters:
            array of objs: of users generated images that has img_id, and prompt
        returns:
            Bool : if successful or not
        */
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

    sendEmail = async () => {
        // TODO
    }


}

export default AWS
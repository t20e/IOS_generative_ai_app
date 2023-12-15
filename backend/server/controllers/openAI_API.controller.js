import setUpApiCLient from '../config/openai_api.config.js';
import { v4 as uuidv4 } from 'uuid';


class OpenAI_Controller {
    constructor (api_key) {
        this.API_client = setUpApiCLient(api_key)
    }

    async generateImg(req, res, next) {
        // user is already authenticated
        console.log("Generating image...")
        // TODO gen image
        // const res = await api_client.images.generate({
        //     'model': "dall-e-3",
        //     'prompt': req.body.prompt,
        //     'size': "1024x1024",
        //     'quality': "standard",
        //     'n': 1,
        // })
        // console.log("Result of generated image:", res)
        // TODO create a UUID for the image

        req.body.image_id = uuidv4()
        // TODO add image to s3 bucket with uuid
        // TODO append that uuid to users images array
        next()
    }
}

export default OpenAI_Controller

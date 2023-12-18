import setUpApiCLient from '../config/openai_api.config.js';
import { v4 as uuidv4 } from 'uuid';


class OpenAI_Controller {
    constructor(api_key, AWS) {
        this.api_client = setUpApiCLient(api_key)
    }
    test_prompt() {
        return {
            created: 1702716456,
            data: [
                {
                    revised_prompt: "An image showing a large green whale exhibiting great strength and agility as it breaches the surface of azure water. The whale's powerful tail is still submerged, sending a rush of foamy white water into the air. The sky overhead is clear and blue, suggesting a sunny day. The sight is striking as it conveys a sense of natural grandeur and beauty.",
                    url: 'https://oaidalleapiprodscus.blob.core.windows.net/private/org-F0vUc4ajn5bEbCS4zY043ZBU/user-gUcOcZ8W9WJnG1zimLRTkTqp/img-wL7OCfatcwEyAgHGbrGmLlHA.png?st=2023-12-16T07%3A47%3A36Z&se=2023-12-16T09%3A47%3A36Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-12-15T20%3A55%3A21Z&ske=2023-12-16T20%3A55%3A21Z&sks=b&skv=2021-08-06&sig=w/BQHMF9Ec873J0hGPp6ue5/6Rsp6JB1vmgW8wcM7f8%3D'
                }
            ]
        }
    }
    generateImg = async (req, res, next) => {
        // user is already authenticated
        console.log("Generating image...")
        try {
            const img_res = await this.api_client.images.generate({
                'model': "dall-e-3",
                'prompt': req.body.prompt,
                'size': "1024x1024",
                'quality': "standard",
                'n': 1,
            })
            // console.log("IMAGE RES:", img_res)
            // const img_res = this.test_prompt()
            // console.log("Result of generated image:", img_res)
            req.body.img_id = uuidv4()
            req.body.img_url = img_res.data[0].url
            if (img_res.data[0].revised_prompt) {
                req.body.prompt = `REVISED:%j&#${img_res.data[0].revised_prompt}`
            }
            next()
        } catch (err) {
            console.log("Error generating image", err)
            return res.status(500).send("error generating image")
        }
    }
}

export default OpenAI_Controller
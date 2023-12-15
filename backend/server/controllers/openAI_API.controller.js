import setUpApiCLient from '../config/openai_api.config.js';
import { v4 as uuidv4 } from 'uuid';


class OpenAI_Controller {
    constructor(api_key, AWS) {
        this.api_client = setUpApiCLient(api_key)
    }
    test_prompt() {
        return {
            created: 1702643244,
            data: [
                {
                    revised_prompt: "Imagine a friendly bear with a bright yellow coat. Its eyes are filled with curiosity as it walks around a lush forest. The color of its fur is radiant, capturing the brightness of a summer's day. The bear's face is round and expressive, communicating a gentle disposition. Its thick fur bristles in the wind, creating a mesmerizing effect of waves in a sea of yellow. The bear is not overly huge, but it still exudes a sense of strength and power, a testament to its survival skills in the wilderness.",
                    url: 'https://oaidalleapiprodscus.blob.core.windows.net/private/org-F0vUc4ajn5bEbCS4zY043ZBU/user-gUcOcZ8W9WJnG1zimLRTkTqp/img-6d58GPevV6eGxL0z9Rh8jeRV.png?st=2023-12-15T11%3A27%3A24Z&se=2023-12-15T13%3A27%3A24Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-12-14T18%3A50%3A49Z&ske=2023-12-15T18%3A50%3A49Z&sks=b&skv=2021-08-06&sig=H0zuJO59KOoi1q/9hIxi0gZaikaNw4S/zHRFHV0vbww%3D'
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

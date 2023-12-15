import OpenAI from "openai";
// Authorization: Bearer OPENAI_API_KEY

const setUpApiCLient = (api_key) => {
    const client = new OpenAI({ 'apiKey': api_key })
    return client
}

export default setUpApiCLient
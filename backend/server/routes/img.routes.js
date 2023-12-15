const imgRoutes = (app, openai_con, userController, AWS) => {
    app.post("/api/v1/imgs/generate",
        userController.authenticateUser, openai_con.generateImg,
        AWS.downloadImgFromUrl, AWS.uploadToS3, userController.addImgKeyToUser
    )
}

export default imgRoutes
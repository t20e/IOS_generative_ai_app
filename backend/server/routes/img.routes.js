const imgRoutes = (app, openAI_con, userController, AWS) => {
    app.post("/api/v1/imgs/generate",
        userController.authenticateUser, userController.canUserGenerateImg, openAI_con.generateImg,
        AWS.downloadImgFromUrl, AWS.uploadToS3, userController.addImgKeyToUser,
        userController.lastUserRequestMiddleware
    )
    // app.get("/api/v1/imgs/getManyPresignedUrls", AWS.getManyObjectsPresignedUrl)
}

export default imgRoutes
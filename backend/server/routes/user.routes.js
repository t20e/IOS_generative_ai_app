
const userRoutes = (app, userController) => {
    app.post("/api/v1/users/checkIfEmailExists", userController.check_if_email_exists)
    app.post("/api/v1/users/reg", userController.register)
    app.post("/api/v1/users/login", userController.login)
    // // the upload.single('profilePic) allows to send a single imgs, this wont allow u to send more than one imgs 
    // // then name inside ex profilePic needs to match whatever u named the img in the obj
    // app.post("/api/user/register", upload.single('profilePic'), UserController.register);
    // app.post("/api/user/login", UserController.login);
    // app.get("/api/user/logUser", UserController.getLoggedUser)
    // app.get("/api/user/logout", UserController.logout)
    // app.put("/api/users/update/:_id",  upload.single('profilePic'), UserController.updateUser)
    // app.get("/api/searchUsers/:name", UserController.searchAllUsers);
    // app.get("/api/users/logout", UserController.logout)
}
export default userRoutes
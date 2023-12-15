import mongoose from "mongoose";

// mongodb+srv://${process.env.DB_USER_NAME}:${process.env.DB_PASSWORD}@personal-projects-db.3ruyg.mongodb.net/${process.env.DB_NAME}?retryWrites=true&w=majority

const connectToMongodb = (MONGODB_USER_NAME, MONGODB_PASSWORD) => {
    const uri = `mongodb+srv://${MONGODB_USER_NAME}:${MONGODB_PASSWORD}@cluster0.dekrdqb.mongodb.net/app_db?retryWrites=true&w=majority`
    mongoose.connect(uri,
        {
            // DEPRECATED METHODS
            // useNewUrlParser: true,
            // useUnifiedTopology: true
        })
        .then(() => console.log('Established a connection to the database'))
        .catch(err => console.log('Something went wrong when connecting to the database ', err));
    // return mongoose
}

export default connectToMongodb
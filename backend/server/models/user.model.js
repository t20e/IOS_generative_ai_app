import Mongoose from 'mongoose';
import bcrypt from 'bcrypt';

const UserSchema = new Mongoose.Schema({
    email: ({
        type: String,
        unique: true,
        required: [true, 'email is required'],
        validate: {
            validator: val => /^([\w-\.]+@([\w-]+\.)+[\w-]+)?$/.test(val),
            message: "Please enter a valid email"
        },
        match: [/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/, 'Please fill a valid email address']
    }),
    password: {
        type: String,
        required: [true, "please enter a password"],
        minlength: [6, "Password must be 6 or more characters"]
    },
    firstName: {
        type: String,
        required: [true, 'first name is required'],
    },
    lastName: {
        type: String,
        required: [true, 'last name is required'],
    },
    age: {
        type: Number,
        required: [true, 'age is required'],
        // min: [13, 'you need to be older than 12'],
        // max: [120, 'age cant be more than 120']
    },
    generated_imgs: [
        /*
            {
                img_id: UUID, #key used to get presigned url for user to be able to access the image
                prompt: either gpt revised use REVISED:%j&# | or its just string
            }
        
        */ 
    ]
}, { timestamps: true })


// UserSchema.virtual('confirmPassword')
//     .get(() => this._confirmPassword)
//     .set(value => this._confirmPassword = value);
// // validate confirm password with password before saving to db
// UserSchema.pre('validate', function (next) {
//     if (this.password !== this.confirmPassword) {
//         this.invalidate('confirmPassword', 'Passwords must match');
//     }
//     next();
// });
UserSchema.pre('save', function (next) {
    bcrypt.hash(this.password, 10)
        .then(hash => {
            this.password = hash;
            next();
        });
});

const UserModel = Mongoose.model('users', UserSchema);
export default UserModel
// module.exports = User;

const generateUnique6DigitNumber = () => {
    return Math.floor(100000 + Math.random() * 900000); // Generates a random 6-digit number
}

export {generateUnique6DigitNumber}
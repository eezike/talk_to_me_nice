// Accessible at https://repl.it/@EmekaEzike1/TalkToMeNiceCS50
// What the server code looks like: 

// apikey
var api = "AIzaSyArkA6SOIOfiy7ZllId7TwSp0Li1tgU5j0";
// google translate library
var googleTranslate = require('google-translate')(api);

// express module
const express = require('express')
// body parser module
const bodyParser = require("body-parser");
// create the web app
const app = express()
const port = 3000

// take post data and parse it into json
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// display a default home screen for the web app
app.get('/', (req, res) => {
  res.send('Talk to Me Nice API')
})

// route for translate
app.post('/api/translate', async (req, res) => {
  // if there was posted data
  if (req.body){
    // get the text and the language
    var text = req.body.text;
    var lang = req.body.lang;

    // translate the text to the language
    googleTranslate.translate(text, lang, function(err, translation) {
      // send the translated text back as json
      result = translation.translatedText
      res.json({result})
    });
  }	
})

// run the app
app.listen(port, () => {
  console.log(`Talk to Me Nice listening at https://TalkToMeNiceCS50.emekaezike1.repl.co:${port}`)
})


"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.taskRunner = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const fetch = require("node-fetch");
admin.initializeApp();
const db = admin.firestore();

exports.taskRunner = functions.runWith({ memory: '2GB'}).pubsub.schedule('0 6 * * *').onRun(async (context) => {


    const tasks = await db.collection('Users').where("membership", "==", true).get();
  

    tasks.forEach(snapshot => {
        const user = snapshot.data();
       

 fetch(`https://api.revenuecat.com/v1/subscribers/${user.uid}`,{
     method: 'GET',
    headers: {

      'Content-Type' : 'application/json',
      'Authorization' :  'Bearer appl_DMHyfXQVKLQgLkWsGRkwqjTIckT'
    }
  }).then(response => 
  		response.json()).then(myJson => {
            const currentDate = new Date();
            const expireDate = new Date(myJson["subscriber"]["subscriptions"]["in.softment.premium"]["expires_date"])
            
            var lastQuotesId = user.lastQuotesId;
            if (lastQuotesId == undefined) {
                lastQuotesId = 0;
            }

           

            if (expireDate > currentDate) {
                     db.collection('DailyInsights').where("count", ">", lastQuotesId + 1).where("count", "<", lastQuotesId + 5).orderBy("count").limit(1).get().then((snapshot) => {


                   snapshot.forEach(snap => {
                    
                            var quote = snap.data()
                    
       
        
        
         const payload = {
              notification: {
                   title: quote.title,
                  body: quote.quotes
              }
         };

        db.collection('Users').doc(user.uid).update({
            lastQuotesId : admin.firestore.FieldValue.increment(1)
        });


         admin.messaging().sendToDevice(user.notiToken, payload)
})

})
            
}
        
        });

    
      
   
        


        
    });
});



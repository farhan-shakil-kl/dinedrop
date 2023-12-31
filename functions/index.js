const functions = require("firebase-functions"); 
 const stripe = require('stripe')(functions.config().stripe.testkey); 
  
 const calculateOrderAmount=(items)=>{ 
     return items; 
  
 } 
 const generateResponse= function(intent){ 
     switch(intent.status){ 
         case 'requires_action': 
             return { 
                 clientSecret: intent.clientSecret, 
                 requiresAction: true, 
                 status: intent.status 
             }; 
         case 'requires_payment_method': 
             return { 
                 "error": "Your card was denied, please provide a new payment method", 
  
  
             }; 
         case "succeeded": 
             console.log("payment succeeded"); 
             return { 
  
                 clientSecret: intent.clientSecret, 
                 status:intent.success 
  
             }; 
  
  
     } 
     return { 
         error:"Failed" 
     }; 
 }; 
  
 exports.StripePayEndpointMethodId = functions.https.onRequest(async (req, res)=>{ 
  
     const {paymentMethodId, items, currency, useStripeSdk}=req.body; 
     const orderAmount = calculateOrderAmount(items); 
  
     try{ 
         if(paymentMethodId){ 
             const params = { 
                 amount:orderAmount*100, 
                 confirm:true, 
                 confirmation_method:'manual', 
                 currency:currency, 
                 payment_method: paymentMethodId, 
                 use_stripe_sdk :useStripeSdk, 
  
             }; 
             const intent = await stripe.paymentIntents.create(params); 
             console.log(`intent: ${intent}`); 
             return res.send(generateResponse(intent)); 
  
  
         } 
         return res.sendStatus(400); 
     } 
     catch (e){ 
         return res.send({error: e.message}); 
  
     } 
 }); 
 exports.StripePayEndpointIntentId = functions.https.onRequest(async (req, res)=>{ 
     const {paymentIntentId} = req.body; 
     try{ 
         if(paymentIntentId){ 
             const intent = await stripe.paymentIntents.confirm(paymentIntentId); 
             return res.send(generateResponse(intent)); 
         } 
  
         return res.sendStatus(400); 
     } 
  
  
  
     catch (e){ 
         return res.send({error:e.message}); 
  
     } 
  
 }); 
 // // Create and Deploy Your First Cloud Functions 
 // // https://firebase.google.com/docs/functions/write-firebase-functions 
 // 
 // exports.helloWorld = functions.https.onRequest((request, response) => { 
 //   functions.logger.info("Hello logs!", {structuredData: true}); 
 //   response.send("Hello from Firebase!"); 
 // });
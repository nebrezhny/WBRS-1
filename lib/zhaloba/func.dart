// const functions = require('firebase-functions');
// const nodemailer = require('nodemailer');
//
// const gmailEmail = functions.config().gmail.email;
// const gmailPassword = functions.config().gmail.password;
//
// const mailTransport = nodemailer.createTransport({
//   service: 'gmail',
//   auth: {
//     user: gmailEmail,
//     pass: gmailPassword,
//   },
// });
//
// exports.submitComplaint = functions.https.onCall(async (data) => {
//   const { violatorId, violationType, description } = data;
//
//   const mailOptions = {
//     from: gmailEmail,
//     to: 'admin@example.com', // Замените на адрес электронной почты администратора
//     subject: 'Новая жалоба на нарушителя',
//     text: `Идентификатор нарушителя: ${violatorId}\nТип нарушения: ${violationType}\nОписание жалобы: ${description}`,
//   };
//
//   try {
//     await mailTransport.sendMail(mailOptions);
//     console.log('Жалоба успешно отправлена на электронную почту администратора');
//     return { success: true };
//   } catch (error) {
//     console.error('Ошибка при отправке жалобы:', error);
//     throw new functions.https.HttpsError('internal', 'Ошибка при отправке жалобы');
//   }
// });
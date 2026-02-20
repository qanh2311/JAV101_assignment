package service;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailService {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_FROM = "anhptqth05962@gmail.com";
    private static final String EMAIL_PASSWORD = "caqv ncge dikp iinn";


    public static boolean sendNewNewsNotification(String newsTitle, String newsCategory,
                                                  String newsAuthor, String recipientEmail) {
        try {
            // Cấu hình properties cho SMTP
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.trust", SMTP_HOST);

            // Tạo session với authentication
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });

            // Tạo message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("🔔 Tin tức mới: " + newsTitle);

            // Nội dung email HTML
            String htmlContent = buildEmailContent(newsTitle, newsCategory, newsAuthor);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            // Gửi email
            Transport.send(message);

            System.out.println("✅ Email sent successfully to: " + recipientEmail);
            return true;

        } catch (MessagingException e) {
            System.err.println("❌ Failed to send email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private static String buildEmailContent(String title, String category, String author) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: 'Segoe UI', Arial, sans-serif; background: #f5f5f5; margin: 0; padding: 20px; }" +
                ".container { max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #000000 0%, #1a1a1a 100%); color: #ffffff; padding: 30px; text-align: center; }" +
                ".header h1 { margin: 0; font-size: 28px; }" +
                ".content { padding: 30px; }" +
                ".news-title { font-size: 22px; color: #000000; margin-bottom: 15px; font-weight: bold; }" +
                ".meta { display: flex; gap: 20px; margin: 20px 0; padding: 15px; background: #f9f9f9; border-radius: 8px; }" +
                ".meta-item { display: flex; align-items: center; gap: 8px; font-size: 14px; color: #666; }" +
                ".meta-item strong { color: #000000; }" +
                ".button { display: inline-block; padding: 14px 28px; background: #000000; color: #ffffff; text-decoration: none; border-radius: 8px; font-weight: bold; margin-top: 20px; }" +
                ".footer { background: #f9f9f9; padding: 20px; text-align: center; color: #999; font-size: 13px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>📰 Tin Tức Mới</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<p style='color: #666; margin-bottom: 20px;'>Chúng tôi vừa đăng một bài viết mới mà bạn có thể quan tâm:</p>" +
                "<div class='news-title'>" + title + "</div>" +
                "<div class='meta'>" +
                "<div class='meta-item'>📂 <strong>" + category + "</strong></div>" +
                "<div class='meta-item'>✍️ Tác giả: <strong>" + author + "</strong></div>" +
                "<div class='footer'>" +
                "<p>Có tin tức mới nhé :))))</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }

    public static void sendBulkEmails(String newsTitle, String newsCategory,
                                      String newsAuthor, String[] recipients) {
        for (String recipient : recipients) {
            sendNewNewsNotification(newsTitle, newsCategory, newsAuthor, recipient);
        }
    }
}
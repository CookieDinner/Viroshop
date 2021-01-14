package pl.put.poznan.viroshop.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class MailService {

    @Value("$spring.mail.username")
    private String senderMail;

    private JavaMailSender javaMailSender;

    public MailService(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    public void sendRegistrationWelcome(String userMail) {
        SimpleMailMessage simpleMailMessage = new SimpleMailMessage();
        simpleMailMessage.setTo(userMail);
        simpleMailMessage.setFrom(senderMail);
        simpleMailMessage.setSubject("Welcome in viroShop!");
        simpleMailMessage.setText("Hi!\n" +
                "We glad, that you joined our community");
        javaMailSender.send(simpleMailMessage);
    }

    public void sendForgotPasswordMail(String userMail, String password) {
        SimpleMailMessage simpleMailMessage = new SimpleMailMessage();
        simpleMailMessage.setTo(userMail);
        simpleMailMessage.setFrom(senderMail);
        simpleMailMessage.setSubject("Welcome in viroShop!");
        simpleMailMessage.setText("Hi!\n" +
                "Your temporary password is " + password);
        javaMailSender.send(simpleMailMessage);
    }
}

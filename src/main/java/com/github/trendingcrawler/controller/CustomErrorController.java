package com.github.trendingcrawler.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.RequestDispatcher;
import org.springframework.http.HttpStatus;

@Controller
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        Object message = request.getAttribute(RequestDispatcher.ERROR_MESSAGE);
        
        if (status != null) {
            Integer statusCode = Integer.valueOf(status.toString());
            model.addAttribute("status", statusCode);
            
            if (message != null) {
                model.addAttribute("message", message.toString());
            }
            
            if(statusCode == HttpStatus.NOT_FOUND.value()) {
                return "error/404";
            }
        }
        return "error";
    }

    public String getErrorPath() {
        return "/error";
    }
}
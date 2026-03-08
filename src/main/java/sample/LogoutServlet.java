package sample;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


// Map this servlet to the URL /LogoutServlet
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get the current session
        HttpSession session = request.getSession(false); // don't create a new session if one doesn't exist

        if (session != null) {
            // 2. Invalidate (destroy) the session
            session.invalidate();
        }
        
        // 3. Redirect the user back to the login page
        response.sendRedirect("login.jsp?logout=success");
    }
    
    // In many apps, logout is triggered via a link (GET), but we can handle POST too.
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
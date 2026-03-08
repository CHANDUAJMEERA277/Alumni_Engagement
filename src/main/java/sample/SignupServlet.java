package sample;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final String DB_URL = "jdbc:mysql://localhost:3306/sample";
    private final String DB_USER = "root";
    private final String DB_PASSWORD = "chandu@7750";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String rollno = request.getParameter("rollno");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password"); 

        if (password == null || !password.equals(confirmPassword) || name == null || name.isEmpty() || email == null || email.isEmpty()) {
            response.sendRedirect("signup.jsp?error=validation_failed&role=" + role);
            return;
        }

        String hashedPassword = password; // plain text for now

        String sql = "INSERT INTO users (role, name, email, roll_number, password_hash) VALUES (?, ?, ?, ?, ?)";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("signup.jsp?error=driver_missing");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, rollno);
            ps.setString(5, hashedPassword); 

            int rowCount = ps.executeUpdate();

            if (rowCount > 0) {
                // ✅ Store user info in session after signup
                HttpSession session = request.getSession();
                session.setAttribute("userEmail", email);
                session.setAttribute("userName", name);
                session.setAttribute("userRole", role);
                session.setAttribute("userRollNo", rollno); 

                // Redirect to dashboard
                if ("student".equalsIgnoreCase(role)) {
                    response.sendRedirect("sd.jsp");
                } else if ("alumni".equalsIgnoreCase(role)) {
                    response.sendRedirect("alumniDashboard.jsp");
                } else if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("adminDashboard.jsp");
                }
            } else {
                response.sendRedirect("signup.jsp?error=db_insert_failed&role=" + role);
            }

        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
            response.sendRedirect("signup.jsp?error=already_exists&role=" + role);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("signup.jsp?error=database_error&role=" + role);
        }
    }
}

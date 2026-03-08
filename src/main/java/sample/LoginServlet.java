package sample;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final String DB_URL = "jdbc:mysql://localhost:3306/sample";
    private final String DB_USER = "root";
    private final String DB_PASSWORD = "chandu@7750";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String emailOrRoll = request.getParameter("email");
        String password = request.getParameter("password");

        if (emailOrRoll == null || emailOrRoll.isEmpty() || password == null || password.isEmpty()) {
            response.sendRedirect("login.jsp?error=missing_credentials&role=" + role);
            return;
        }

        String sql;
        if ("admin".equalsIgnoreCase(role)) {
            sql = "SELECT * FROM users WHERE email = ? AND role = ? AND password_hash = ?";
        } else {
            sql = "SELECT * FROM users WHERE (email = ? OR roll_number = ?) AND role = ? AND password_hash = ?";
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                if ("admin".equalsIgnoreCase(role)) {
                    ps.setString(1, emailOrRoll);
                    ps.setString(2, role);
                    ps.setString(3, password);
                } else {
                    ps.setString(1, emailOrRoll);
                    ps.setString(2, emailOrRoll);
                    ps.setString(3, role);
                    ps.setString(4, password);
                }

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        HttpSession session = request.getSession();
                        session.setAttribute("userEmail", rs.getString("email"));
                        session.setAttribute("userName", rs.getString("name"));
                        session.setAttribute("userRole", rs.getString("role"));
                        session.setAttribute("userRollNo", rs.getString("roll_number"));
                        session.setMaxInactiveInterval(30 * 60);

                        if ("admin".equalsIgnoreCase(role)) {
                            response.sendRedirect("admin_dashboard.jsp");
                        } else if ("alumni".equalsIgnoreCase(role)) {
                            response.sendRedirect("alumniDashboard.jsp");
                        } else {
                            response.sendRedirect("sd.jsp");
                        }
                    } else {
                        response.sendRedirect("login.jsp?error=invalid_credentials&role=" + role);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=database_error&message=" + e.getMessage());
        }
    }
}

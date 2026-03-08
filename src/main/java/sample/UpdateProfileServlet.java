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

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/sample";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "chandu@7750";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = (String) session.getAttribute("userEmail");

        String gradYear = request.getParameter("gradYear");
        String company = request.getParameter("company");
        String designation = request.getParameter("designation");
        String lpa = request.getParameter("lpa");
        String linkedin = request.getParameter("linkedin");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("sd.jsp?error=driver_missing");
            return;
        }

        String sql = "UPDATE users SET grad_year=?, company=?, designation=?, lpa=?, linkedin=? WHERE email=?";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, gradYear);
            ps.setString(2, company);
            ps.setString(3, designation);
            ps.setString(4, lpa);
            ps.setString(5, linkedin);
            ps.setString(6, email);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("sd.jsp?success=updated");
            } else {
                response.sendRedirect("sd.jsp?error=not_found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("sd.jsp?error=database_error");
        }
    }
}

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

@WebServlet("/PostJobServlet")
public class PostJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String postedBy = request.getParameter("posted_by_email");
        String company = request.getParameter("company");
        String role = request.getParameter("role");
        String location = request.getParameter("location");
        String lpa = request.getParameter("lpa");
        String type = request.getParameter("type");
        String description = request.getParameter("description");
        String applyLink = request.getParameter("apply_link");

        String url = "jdbc:mysql://localhost:3306/sample?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPassword = "chandu@7750";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // Correct table name and column names
            String sql = "INSERT INTO jobs_posts(posted_by_email, company, role, location, lpa, type, description, apply_link) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, postedBy);
            ps.setString(2, company);
            ps.setString(3, role);
            ps.setString(4, location);
            ps.setString(5, lpa);
            ps.setString(6, type);
            ps.setString(7, description);
            ps.setString(8, applyLink);

            ps.executeUpdate();
            ps.close();
            conn.close();

            response.sendRedirect("alumniDashboard.jsp?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

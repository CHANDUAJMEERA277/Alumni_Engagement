<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // Session validation
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    String userRollNo = (String) session.getAttribute("userRollNo");

    if(userEmail == null || !"student".equalsIgnoreCase(userRole)){
        response.sendRedirect("login.jsp");
        return;
    }

    // Initialize variables
    String gradYear="", company="", designation="", lpa="", linkedin="";
    List<Map<String,String>> alumniList = new ArrayList<>();
    List<Map<String,String>> jobsList = new ArrayList<>();

    String searchQuery = request.getParameter("search") != null ? request.getParameter("search").trim() : "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sample?useSSL=false&serverTimezone=UTC","root","chandu@7750");

        // Fetch student profile
        ps = conn.prepareStatement("SELECT grad_year, company, designation, lpa, linkedin FROM users WHERE email=?");
        ps.setString(1,userEmail);
        rs = ps.executeQuery();
        if(rs.next()){
            gradYear = rs.getString("grad_year") != null ? rs.getString("grad_year") : "";
            company = rs.getString("company") != null ? rs.getString("company") : "";
            designation = rs.getString("designation") != null ? rs.getString("designation") : "";
            lpa = rs.getString("lpa") != null ? rs.getString("lpa") : "";
            linkedin = rs.getString("linkedin") != null ? rs.getString("linkedin") : "";
        }
        rs.close(); ps.close();

        // Fetch alumni list
        String alumniSQL = "SELECT name, grad_year, company, designation, linkedin FROM users WHERE role='alumni'";
        if(!searchQuery.isEmpty()){
            alumniSQL += " AND (name LIKE ? OR grad_year LIKE ? OR company LIKE ?)";
            ps = conn.prepareStatement(alumniSQL);
            String likeQuery = "%" + searchQuery + "%";
            ps.setString(1,likeQuery);
            ps.setString(2,likeQuery);
            ps.setString(3,likeQuery);
        } else {
            ps = conn.prepareStatement(alumniSQL);
        }
        rs = ps.executeQuery();
        while(rs.next()){
            Map<String,String> alumni = new HashMap<>();
            alumni.put("name", rs.getString("name"));
            alumni.put("grad_year", rs.getString("grad_year"));
            alumni.put("company", rs.getString("company"));
            alumni.put("designation", rs.getString("designation"));
            alumni.put("linkedin", rs.getString("linkedin"));
            alumniList.add(alumni);
        }
        rs.close(); ps.close();

        // Fetch job posts
        ps = conn.prepareStatement("SELECT company, role, location, type, lpa, description, apply_link, created_at FROM jobs_posts ORDER BY created_at DESC");
        rs = ps.executeQuery();
        while(rs.next()){
            Map<String,String> job = new HashMap<>();
            job.put("company", rs.getString("company"));
            job.put("role", rs.getString("role"));
            job.put("location", rs.getString("location"));
            job.put("type", rs.getString("type"));
            job.put("lpa", rs.getString("lpa"));
            job.put("description", rs.getString("description"));
            job.put("apply_link", rs.getString("apply_link"));
            job.put("created_at", rs.getTimestamp("created_at").toString());
            jobsList.add(job);
        }
        rs.close(); ps.close();

    } catch(Exception e){
        e.printStackTrace();
    } finally {
        try{ if(rs!=null) rs.close(); } catch(Exception e){}
        try{ if(ps!=null) ps.close(); } catch(Exception e){}
        try{ if(conn!=null) conn.close(); } catch(Exception e){}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Student Dashboard | Alumni Connect</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-indigo-600 to-purple-700 min-h-screen text-white">

<!-- Header -->
<header class="flex justify-between items-center p-6 bg-indigo-800 bg-opacity-70 backdrop-blur-md shadow-lg rounded-b-2xl">
    <h1 class="text-3xl font-extrabold">🎓 Alumni Connect</h1>
    <div class="flex items-center space-x-4">
        <span class="text-sm text-gray-200">Logged in as: <span class="font-bold"><%= userRole %></span></span>
        <form action="LogoutServlet" method="post">
            <button type="submit" class="bg-red-500 hover:bg-red-600 px-4 py-2 rounded-lg font-semibold text-white transition">Logout</button>
        </form>
    </div>
</header>

<main class="max-w-6xl mx-auto mt-10 px-4">
    <p class="text-lg text-gray-200 mb-8">Welcome, <span class="font-bold"><%= userName %></span>! Explore your student dashboard.</p>

    <!-- Dashboard Cards -->
    <div id="dashboard-grid" class="grid grid-cols-1 md:grid-cols-3 gap-6">

        <!-- Alumni Directory Card -->
        <a href="#" data-target="alumni-subview" class="dashboard-card block p-6 bg-white text-gray-800 rounded-2xl shadow-lg hover:shadow-2xl transform hover:-translate-y-1 transition">
            <div class="text-purple-600 mb-3">🎓</div>
            <h2 class="text-xl font-bold mb-2">Alumni Directory</h2>
            <p class="text-gray-600 text-sm">Find alumni by company, graduation year, or name.</p>
        </a>

        <!-- Job Posts Card -->
        <a href="#" data-target="jobs-subview" class="dashboard-card block p-6 bg-white text-gray-800 rounded-2xl shadow-lg hover:shadow-2xl transform hover:-translate-y-1 transition">
            <div class="text-pink-600 mb-3">💼</div>
            <h2 class="text-xl font-bold mb-2">Job & Internship Posts</h2>
            <p class="text-gray-600 text-sm">Explore the latest career opportunities.</p>
        </a>

        <!-- My Profile Card -->
        <a href="#" data-target="profile-subview" class="dashboard-card block p-6 bg-white text-gray-800 rounded-2xl shadow-lg hover:shadow-2xl transform hover:-translate-y-1 transition">
            <div class="text-indigo-600 mb-3">👤</div>
            <h2 class="text-xl font-bold mb-2">My Profile</h2>
            <p class="text-gray-600 text-sm">Update your details and current info.</p>
        </a>

    </div>

    <!-- Alumni Directory Subview -->
    <div id="alumni-subview" class="hidden bg-white text-gray-800 p-8 rounded-2xl shadow-lg mt-8 max-w-6xl mx-auto relative">
        <button class="back-dashboard absolute top-4 left-4 flex items-center space-x-2 text-purple-600 hover:text-purple-800 font-semibold transition">← Back</button>
        <h2 class="text-2xl font-bold text-purple-700 mb-6 text-center">🎓 Alumni Directory</h2>

        <form method="get" class="mb-4 flex justify-center">
            <input type="text" name="search" value="<%= searchQuery %>" placeholder="Search by name, year, or company" class="p-2 border rounded-l-lg w-1/3"/>
            <button type="submit" class="bg-purple-600 text-white px-4 rounded-r-lg hover:bg-purple-700">Search</button>
        </form>

        <div class="overflow-x-auto">
            <table class="min-w-full border border-gray-300 rounded-xl overflow-hidden">
                <thead class="bg-purple-100">
                    <tr>
                        <th class="py-3 px-4 text-left font-semibold">Name</th>
                        <th class="py-3 px-4 text-left font-semibold">Batch</th>
                        <th class="py-3 px-4 text-left font-semibold">Company</th>
                        <th class="py-3 px-4 text-left font-semibold">Designation</th>
                        <th class="py-3 px-4 text-left font-semibold">LinkedIn</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Map<String,String> alum : alumniList) { %>
                        <tr class="border-t">
                            <td class="py-3 px-4"><%= alum.get("name") %></td>
                            <td class="py-3 px-4"><%= alum.get("grad_year") %></td>
                            <td class="py-3 px-4"><%= alum.get("company") %></td>
                            <td class="py-3 px-4"><%= alum.get("designation") %></td>
                            <td class="py-3 px-4">
                                <a href="<%= alum.get("linkedin") %>" target="_blank" class="text-indigo-600 hover:underline">View Profile</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Job Posts Subview -->
    <div id="jobs-subview" class="hidden bg-white text-gray-800 p-8 rounded-2xl shadow-lg mt-8 max-w-6xl mx-auto relative">
        <button class="back-dashboard absolute top-4 left-4 flex items-center space-x-2 text-pink-600 hover:text-pink-800 font-semibold transition">← Back</button>
        <h2 class="text-2xl font-bold text-pink-600 mb-6 text-center">Job & Internship Posts</h2>

        <div class="overflow-x-auto">
            <table class="min-w-full border border-gray-300 rounded-xl overflow-hidden">
                <thead class="bg-pink-100">
                    <tr>
                        <th class="py-3 px-4 text-left font-semibold">Company</th>
                        <th class="py-3 px-4 text-left font-semibold">Role</th>
                        <th class="py-3 px-4 text-left font-semibold">Location</th>
                        <th class="py-3 px-4 text-left font-semibold">Type</th>
                        <th class="py-3 px-4 text-left font-semibold">LPA / Stipend</th>
                        <th class="py-3 px-4 text-left font-semibold">Description</th>
                        <th class="py-3 px-4 text-left font-semibold">Apply Link</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Map<String,String> job : jobsList) { %>
                        <tr class="border-t">
                            <td class="py-3 px-4"><%= job.get("company") %></td>
                            <td class="py-3 px-4"><%= job.get("role") %></td>
                            <td class="py-3 px-4"><%= job.get("location") %></td>
                            <td class="py-3 px-4"><%= job.get("type") %></td>
                            <td class="py-3 px-4"><%= job.get("lpa") %></td>
                            <td class="py-3 px-4"><%= job.get("description") %></td>
                            <td class="py-3 px-4"><a href="<%= job.get("apply_link") %>" target="_blank" class="text-pink-600 hover:underline">Apply</a></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- My Profile Subview -->
    <div id="profile-subview" class="hidden bg-white text-gray-800 p-8 rounded-2xl shadow-lg mt-8 max-w-4xl mx-auto relative">
        <button class="back-dashboard absolute top-4 left-4 flex items-center space-x-2 text-indigo-600 hover:text-indigo-800 font-semibold transition">← Back</button>
        <h2 class="text-2xl font-bold text-indigo-600 mb-6 text-center">My Profile & Updates</h2>

        <form action="UpdateProfileServlet" method="post" class="space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block font-semibold mb-1">Roll No</label>
                    <input type="text" name="roll_number" value="<%= userRollNo %>" class="w-full p-3 border rounded-lg bg-gray-100" readonly/>
                </div>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block font-semibold mb-1">Graduation Year</label>
                    <input type="text" name="gradYear" value="<%= gradYear %>" class="w-full p-3 border rounded-lg"/>
                </div>
                <div>
                    <label class="block font-semibold mb-1">Current Company</label>
                    <input type="text" name="company" value="<%= company %>" class="w-full p-3 border rounded-lg"/>
                </div>
                <div>
                    <label class="block font-semibold mb-1">Designation</label>
                    <input type="text" name="designation" value="<%= designation %>" class="w-full p-3 border rounded-lg"/>
                </div>
                <div>
                    <label class="block font-semibold mb-1">Highest LPA</label>
                    <input type="text" name="lpa" value="<%= lpa %>" class="w-full p-3 border rounded-lg"/>
                </div>
                <div class="md:col-span-2">
                    <label class="block font-semibold mb-1">LinkedIn</label>
                    <input type="text" name="linkedin" value="<%= linkedin %>" class="w-full p-3 border rounded-lg"/>
                </div>
            </div>
            <button type="submit" class="w-full bg-indigo-600 text-white font-bold py-3 rounded-lg hover:bg-indigo-700 transition">Save Changes</button>
        </form>
    </div>

</main>

<footer class="text-center text-gray-200 mt-10 py-4 border-t border-gray-500">
    © 2025 Alumni Connect | Student Portal
</footer>

<script>
document.querySelectorAll('.dashboard-card').forEach(card => {
    card.addEventListener('click', e => {
        e.preventDefault();
        const target = card.getAttribute('data-target');
        document.getElementById('dashboard-grid').classList.add('hidden');
        document.querySelectorAll('#profile-subview, #alumni-subview, #jobs-subview').forEach(sub => sub.classList.add('hidden'));
        document.getElementById(target).classList.remove('hidden');
    });
});

document.querySelectorAll('.back-dashboard').forEach(btn => {
    btn.addEventListener('click', e => {
        e.preventDefault();
        document.getElementById('dashboard-grid').classList.remove('hidden');
        document.querySelectorAll('#profile-subview, #alumni-subview, #jobs-subview').forEach(sub => sub.classList.add('hidden'));
    });
});
</script>

</body>
</html>

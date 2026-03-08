<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName  = (String) session.getAttribute("userName");
    String userRole  = (String) session.getAttribute("userRole");

    if(userEmail == null || !"alumni".equalsIgnoreCase(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // DB Connection
    String url = "jdbc:mysql://localhost:3306/sample?useSSL=false&serverTimezone=UTC";
    String dbUser = "root";
    String dbPassword = "chandu@7750";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String gradYear="", company="", designation="", lpa="", linkedin="";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        // Fetch alumni profile
        ps = conn.prepareStatement("SELECT grad_year, company, designation, lpa, linkedin FROM users WHERE email=? AND role='alumni'");
        ps.setString(1, userEmail);
        rs = ps.executeQuery();
        if(rs.next()){
            gradYear = rs.getString("grad_year");
            company = rs.getString("company");
            designation = rs.getString("designation");
            lpa = rs.getString("lpa");
            linkedin = rs.getString("linkedin");
        }
        rs.close();
        ps.close();

        // Fetch all alumni for directory
        ps = conn.prepareStatement("SELECT name, grad_year, company, designation, linkedin FROM users WHERE role='alumni'");
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Alumni Dashboard | Alumni Connect</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-green-600 to-blue-700 min-h-screen text-white">

  <!-- Header -->
  <header class="flex justify-between items-center p-6 bg-green-800 bg-opacity-70 backdrop-blur-md shadow-lg rounded-b-2xl">
    <h1 class="text-3xl font-extrabold">🎓 Alumni Connect</h1>
    <div class="flex items-center space-x-4">
      <span class="text-sm text-gray-200">Logged in as: <span class="font-bold"><%= userRole %></span></span>
      <form action="LogoutServlet" method="post">
        <button type="submit" class="bg-red-500 hover:bg-red-600 px-4 py-2 rounded-lg font-semibold text-white transition">Logout</button>
      </form>
    </div>
  </header>

  <!-- Main Dashboard -->
  <main class="max-w-6xl mx-auto mt-10 px-4">
    <p class="text-lg text-gray-200 mb-8">
      Welcome, <span class="font-bold"><%= userName %></span>! Explore your alumni dashboard.
    </p>

    <!-- Dashboard Cards -->
    <div id="dashboard-grid" class="grid grid-cols-1 md:grid-cols-4 gap-6">

      <!-- Alumni Directory Card -->
      <a href="#" data-target="alumni-subview" class="dashboard-card block p-6 bg-white text-gray-800 rounded-2xl shadow-lg hover:shadow-2xl transform hover:-translate-y-1 transition">
        <div class="text-blue-600 mb-3">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20v-2c0-.656-.126-1.283-.356-1.857M9 20H4v-2a3 3 0 015-2.236M9 20v-2a3 3 0 00-5.356-1.857M6 12a3 3 0 11-6 0 3 3 0 016 0zM12 12a3 3 0 11-6 0 3 3 0 016 0zM18 12a3 3 0 11-6 0 3 3 0 016 0zM17 9V7a3 3 0 00-6-3v2m6 3H6a3 3 0 010-6h10a3 3 0 010 6z" />
          </svg>
        </div>
        <h2 class="text-xl font-bold mb-2">Alumni Directory</h2>
        <p class="text-gray-600 text-sm">Find fellow alumni by company, batch, or designation.</p>
      </a>

      <!-- My Profile Card -->
      <a href="#" data-target="profile-subview" class="dashboard-card block p-6 bg-white text-gray-800 rounded-2xl shadow-lg hover:shadow-2xl transform hover:-translate-y-1 transition">
        <div class="text-green-600 mb-3">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <h2 class="text-xl font-bold mb-2">My Profile</h2>
        <p class="text-gray-600 text-sm">Update your details and current info.</p>
      </a>

      <!-- Post Job / Internship Card -->
      <a href="#" data-target="job-post-subview" class="dashboard-card block p-6 bg-white text-gray-800 rounded-2xl shadow-lg hover:shadow-2xl transform hover:-translate-y-1 transition">
        <div class="text-pink-600 mb-3">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m2 0h2M7 0v24H1V0h6zm2 6h10m-2 0v6" />
          </svg>
        </div>
        <h2 class="text-xl font-bold mb-2">Post Job / Internship</h2>
        <p class="text-gray-600 text-sm">Share job or internship opportunities with students.</p>
      </a>

    </div>

    <!-- Alumni Directory Subview -->
    <div id="alumni-subview" class="hidden bg-white text-gray-800 p-8 rounded-2xl shadow-lg mt-8 max-w-6xl mx-auto relative">
      <button class="back-dashboard absolute top-4 left-4 flex items-center space-x-2 text-blue-600 hover:text-blue-800 font-semibold transition">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        <span>Back</span>
      </button>

      <h2 class="text-2xl font-bold text-blue-700 mb-6 text-center">🎓 Alumni Directory</h2>
      <div class="overflow-x-auto">
        <table class="min-w-full border border-gray-300 rounded-xl overflow-hidden">
          <thead class="bg-blue-100">
            <tr>
              <th class="py-3 px-4 text-left font-semibold">Name</th>
              <th class="py-3 px-4 text-left font-semibold">Batch</th>
              <th class="py-3 px-4 text-left font-semibold">Company</th>
              <th class="py-3 px-4 text-left font-semibold">Designation</th>
              <th class="py-3 px-4 text-left font-semibold">LinkedIn</th>
            </tr>
          </thead>
          <tbody>
<%
        while(rs.next()){
%>
            <tr class="border-t">
              <td class="py-3 px-4"><%= rs.getString("name") %></td>
              <td class="py-3 px-4"><%= rs.getString("grad_year") %></td>
              <td class="py-3 px-4"><%= rs.getString("company") %></td>
              <td class="py-3 px-4"><%= rs.getString("designation") %></td>
              <td class="py-3 px-4">
                <a href="<%= rs.getString("linkedin") %>" target="_blank" class="text-blue-600 hover:underline">View Profile</a>
              </td>
            </tr>
<%
        }
        rs.close();
        ps.close();
%>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Profile Subview -->
    <div id="profile-subview" class="hidden bg-white text-gray-800 p-8 rounded-2xl shadow-lg mt-8 max-w-4xl mx-auto relative">
      <button class="back-dashboard absolute top-4 left-4 flex items-center space-x-2 text-green-600 hover:text-green-800 font-semibold transition">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        <span>Back</span>
      </button>

      <h2 class="text-2xl font-bold text-green-600 mb-6 text-center">My Profile & Updates</h2>
      
      <form action="UpdateProfileServlet" method="post" class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block font-semibold mb-1">Graduation Year</label>
            <input type="text" name="gradYear" value="<%= gradYear %>" class="w-full p-3 border rounded-lg" />
          </div>
          <div>
            <label class="block font-semibold mb-1">Current Company</label>
            <input type="text" name="company" value="<%= company %>" class="w-full p-3 border rounded-lg" />
          </div>
          <div>
            <label class="block font-semibold mb-1">Designation</label>
            <input type="text" name="designation" value="<%= designation %>" class="w-full p-3 border rounded-lg" />
          </div>
          <div>
            <label class="block font-semibold mb-1">Highest LPA</label>
            <input type="text" name="lpa" value="<%= lpa %>" class="w-full p-3 border rounded-lg" />
          </div>
          <div class="md:col-span-2">
            <label class="block font-semibold mb-1">LinkedIn</label>
            <input type="text" name="linkedin" value="<%= linkedin %>" class="w-full p-3 border rounded-lg" />
          </div>
        </div>
        <button type="submit" class="w-full bg-green-600 text-white font-bold py-3 rounded-lg hover:bg-green-700 transition">
          Save Changes
        </button>
      </form>
    </div>

    <!-- Job Posting Subview -->
    <div id="job-post-subview" class="hidden bg-white text-gray-800 p-8 rounded-2xl shadow-lg mt-8 max-w-4xl mx-auto relative">
      <button class="back-dashboard absolute top-4 left-4 flex items-center space-x-2 text-pink-600 hover:text-pink-800 font-semibold transition">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        <span>Back</span>
      </button>

      <h2 class="text-2xl font-bold text-pink-600 mb-6 text-center">Post Job / Internship</h2>
      
      <form action="PostJobServlet" method="post" class="space-y-6">
        <input type="hidden" name="posted_by_email" value="<%= userEmail %>" />
        <div class="grid grid-cols-1 gap-4">
          <div>
            <label class="block font-semibold mb-1">Company</label>
            <input type="text" name="company" class="w-full p-3 border rounded-lg" required/>
          </div>
          <div>
            <label class="block font-semibold mb-1">Role / Designation</label>
            <input type="text" name="role" class="w-full p-3 border rounded-lg" required/>
          </div>
          <div>
            <label class="block font-semibold mb-1">Location</label>
            <input type="text" name="location" class="w-full p-3 border rounded-lg"/>
          </div>
          <div>
            <label class="block font-semibold mb-1">LPA / Stipend</label>
            <input type="text" name="lpa" class="w-full p-3 border rounded-lg"/>
          </div>
          <div>
            <label class="block font-semibold mb-1">Type</label>
            <select name="type" class="w-full p-3 border rounded-lg">
              <option value="Job">Job</option>
              <option value="Internship">Internship</option>
            </select>
          </div>
          <div>
            <label class="block font-semibold mb-1">Description</label>
            <textarea name="description" class="w-full p-3 border rounded-lg" rows="4"></textarea>
          </div>
          <div>
            <label class="block font-semibold mb-1">Apply Link</label>
            <input type="text" name="apply_link" class="w-full p-3 border rounded-lg"/>
          </div>
        </div>
        <button type="submit" class="w-full bg-pink-600 text-white font-bold py-3 rounded-lg hover:bg-pink-700 transition">Post Job / Internship</button>
      </form>
    </div>

  </main>

  <!-- Footer -->
  <footer class="text-center text-gray-200 mt-10 py-4 border-t border-gray-500">
    © 2025 Alumni Connect | Alumni Portal
  </footer>

  <!-- JS: View Toggle -->
  <script>
    document.querySelectorAll('.dashboard-card').forEach(card => {
      card.addEventListener('click', e => {
        e.preventDefault();
        const target = card.getAttribute('data-target');
        document.getElementById('dashboard-grid').classList.add('hidden');
        document.getElementById(target).classList.remove('hidden');
      });
    });

    document.querySelectorAll('.back-dashboard').forEach(btn => {
      btn.addEventListener('click', e => {
        e.preventDefault();
        document.getElementById('dashboard-grid').classList.remove('hidden');
        document.querySelectorAll('#profile-subview, #alumni-subview, #job-post-subview').forEach(sub => sub.classList.add('hidden'));
      });
    });
  </script>

</body>
</html>

<%
    } catch(Exception e){
        out.println("Error: " + e.getMessage());
    } finally {
        if(rs!=null) rs.close();
        if(ps!=null) ps.close();
        if(conn!=null) conn.close();
    }
%>

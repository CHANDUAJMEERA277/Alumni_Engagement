<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = request.getParameter("role");
    if (role == null) role = "student";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Alumni Connect | Login</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    .hover-scale:hover { transform: scale(1.05); transition: transform 0.3s ease; }
    .hover-shadow:hover { box-shadow: 0 10px 25px rgba(0,0,0,0.2); transition: box-shadow 0.3s ease; }
    .tab-active { background-color: #4f46e5; color: white; }
    .tab-inactive { background-color: #e5e7eb; color: #374151; }
  </style>
  <script>
    function toggleForm(role) {
      const forms = document.querySelectorAll('.login-form');
      forms.forEach(f => f.classList.add('hidden'));
      document.getElementById(role).classList.remove('hidden');

      document.querySelectorAll('.tab-button').forEach(btn => {
        btn.classList.remove('tab-active');
        btn.classList.add('tab-inactive');
      });
      document.getElementById(role + '-tab').classList.add('tab-active');
      document.getElementById(role + '-tab').classList.remove('tab-inactive');
    }

    document.addEventListener('DOMContentLoaded', () => {
        const initialRole = '<%= role %>';
        toggleForm(initialRole);
    });
  </script>
</head>
<body class="bg-gradient-to-r from-indigo-600 to-purple-600 min-h-screen flex items-center justify-center">

  <div class="bg-white rounded-3xl shadow-2xl max-w-4xl w-full md:flex overflow-hidden hover-shadow">
    
    <div class="hidden md:flex w-1/2 bg-gradient-to-br from-indigo-500 to-purple-600 justify-center items-center">
      <div class="text-center text-white p-8">
        <h1 class="text-4xl font-bold mb-4">Welcome Back!</h1>
        <p class="text-lg">Login to connect students, alumni, and administrators together.</p>
      </div>
    </div>

    <div class="w-full md:w-1/2 p-10">
      <h2 class="text-3xl font-bold text-indigo-600 mb-6 text-center">Login</h2>

      <div class="flex justify-center mb-8 gap-4">
        <button id="student-tab" onclick="toggleForm('student')" 
          class="tab-button <%= role.equals("student") ? "tab-active" : "tab-inactive" %> px-4 py-2 rounded-lg hover-scale">Student</button>
        <button id="alumni-tab" onclick="toggleForm('alumni')" 
          class="tab-button <%= role.equals("alumni") ? "tab-active" : "tab-inactive" %> px-4 py-2 rounded-lg hover-scale">Alumni</button>
        <button id="admin-tab" onclick="toggleForm('admin')" 
          class="tab-button <%= role.equals("admin") ? "tab-active" : "tab-inactive" %> px-4 py-2 rounded-lg hover-scale">Admin</button>
      </div>

      <!-- Student Form -->
      <form id="student" class="login-form hidden" action="LoginServlet" method="post">
        <input type="hidden" name="role" value="student">
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Email</label>
          <input type="email" name="email" placeholder="Enter Email" required
                 class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow">
        </div>
        <div class="mb-6">
          <label class="block text-gray-700 font-semibold mb-2">Password</label>
          <input type="password" name="password" placeholder="Enter Password" required
                 class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow">
        </div>
        <button type="submit" 
                class="w-full py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 hover-scale font-semibold transition">
          Login as Student
        </button>
      </form>

      <!-- Alumni Form -->
      <form id="alumni" class="login-form hidden" action="LoginServlet" method="post">
        <input type="hidden" name="role" value="alumni">
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Email</label>
          <input type="email" name="email" placeholder="Enter Email" required
                 class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow">
        </div>
        <div class="mb-6">
          <label class="block text-gray-700 font-semibold mb-2">Password</label>
          <input type="password" name="password" placeholder="Enter Password" required
                 class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow">
        </div>
        <button type="submit" 
                class="w-full py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 hover-scale font-semibold transition">
          Login as Alumni
        </button>
      </form>

      <!-- Admin Form -->
      <form id="admin" class="login-form hidden" action="LoginServlet" method="post">
        <input type="hidden" name="role" value="admin">
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Admin Email</label>
          <input type="email" name="email" placeholder="Enter Admin Email" required
                 class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow">
        </div>
        <div class="mb-6">
          <label class="block text-gray-700 font-semibold mb-2">Password</label>
          <input type="password" name="password" placeholder="Enter Password" required
                 class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow">
        </div>
        <button type="submit" 
                class="w-full py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 hover-scale font-semibold transition">
          Login as Admin
        </button>
      </form>

      <p class="mt-6 text-center text-gray-500">
        Don’t have an account? 
        <a href="signup.jsp" class="text-indigo-600 hover:underline font-semibold">Sign Up</a>
      </p>
    </div>
  </div>
</body>
</html>

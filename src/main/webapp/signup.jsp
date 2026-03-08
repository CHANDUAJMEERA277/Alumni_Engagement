<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // Get 'role' from the URL (e.g., index.jsp?role=alumni) to pre-select the tab
  String role = request.getParameter("role");
  if (role == null) role = "student"; // default tab
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Alumni Connect - Sign Up</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    .hover-scale:hover { transform: scale(1.05); transition: transform 0.3s ease; }
    .hover-shadow:hover { box-shadow: 0 10px 25px rgba(0,0,0,0.2); transition: box-shadow 0.3s ease; }
    .tab-active { background-color: #4f46e5; color: white; }
    .tab-inactive { background-color: #e5e7eb; color: #374151; }
  </style>
  <script>
    // Function to switch between Student, Alumni, and Admin forms
    function toggleForm(module) {
      const forms = document.querySelectorAll('.signup-form');
      forms.forEach(f => f.classList.add('hidden'));
      document.getElementById(module).classList.remove('hidden');

      // Update the visual state of the tabs
      document.querySelectorAll('.tab-button').forEach(btn => {
        btn.classList.remove('tab-active');
        btn.classList.add('tab-inactive');
      });
      document.getElementById(module + '-tab').classList.add('tab-active');
      document.getElementById(module + '-tab').classList.remove('tab-inactive');
    }
    
    // Initialize the correct tab on page load
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
        <h1 class="text-4xl font-bold mb-4">Join AlumniConnect!</h1>
        <p class="text-lg">Sign up as Student, Alumni, or Admin and connect with your community.</p>
      </div>
    </div>

    <div class="w-full md:w-1/2 p-10 relative">
      <h2 class="text-3xl font-bold text-indigo-600 mb-6 text-center">Sign Up</h2>

      <div class="flex justify-center mb-8 gap-4">
        <button id="student-tab" onclick="toggleForm('student')" class="tab-button <%= role.equals("student") ? "tab-active" : "tab-inactive" %> px-4 py-2 rounded-lg hover-scale">Student</button>
        <button id="alumni-tab" onclick="toggleForm('alumni')" class="tab-button <%= role.equals("alumni") ? "tab-active" : "tab-inactive" %> px-4 py-2 rounded-lg hover-scale">Alumni</button>
        <button id="admin-tab" onclick="toggleForm('admin')" class="tab-button <%= role.equals("admin") ? "tab-active" : "tab-inactive" %> px-4 py-2 rounded-lg hover-scale">Admin</button>
      </div>

      <form id="student" class="signup-form hidden" action="${pageContext.request.contextPath}/SignupServlet" method="post">
        <input type="hidden" name="role" value="student">
        
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Full Name</label>
          <input type="text" name="name" placeholder="Enter Full Name" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Email</label>
          <input type="email" name="email" placeholder="Enter Email" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Roll Number</label>
          <input type="text" name="rollno" placeholder="Enter Roll Number" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Password</label>
          <input type="password" name="password" placeholder="Create Password" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <div class="mb-6">
          <label class="block text-gray-700 font-semibold mb-2">Confirm Password</label>
          <input type="password" name="confirm_password" placeholder="Confirm Password" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <button type="submit" class="w-full py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 hover-scale font-semibold transition">Sign Up as Student</button>
      </form>

      <form id="alumni" class="signup-form hidden" action="${pageContext.request.contextPath}/SignupServlet" method="post">
        <input type="hidden" name="role" value="alumni">
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Full Name</label>
          <input type="text" name="name" placeholder="Enter Full Name" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Email</label>
          <input type="email" name="email" placeholder="Enter Email" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Roll Number (Optional)</label>
          <input type="text" name="rollno" placeholder="Enter Graduating Roll Number" class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Password</label>
          <input type="password" name="password" placeholder="Create Password" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <div class="mb-6">
          <label class="block text-gray-700 font-semibold mb-2">Confirm Password</label>
          <input type="password" name="confirm_password" placeholder="Confirm Password" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <button type="submit" class="w-full py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 hover-scale font-semibold transition">Sign Up as Alumni</button>
      </form>

      <form id="admin" class="signup-form hidden" action="${pageContext.request.contextPath}/SignupServlet" method="post">
        <input type="hidden" name="role" value="admin">
        <p class="text-gray-600 mb-4 text-center">Admin accounts require verification.</p>
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Admin Name</label>
          <input type="text" name="name" placeholder="Enter Name" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Email (Institutional)</label>
          <input type="email" name="email" placeholder="Enter Official Email" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <div class="mb-4">
          <label class="block text-gray-700 font-semibold mb-2">Password</label>
          <input type="password" name="password" placeholder="Create Password" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <div class="mb-6">
          <label class="block text-gray-700 font-semibold mb-2">Confirm Password</label>
          <input type="password" name="confirm_password" placeholder="Confirm Password" required class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-600 hover-shadow"/>
        </div>
        <button type="submit" class="w-full py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 hover-scale font-semibold transition">Sign Up as Admin</button>
      </form>

      <p class="mt-6 text-center text-gray-500">Already have an account? 
        <a href="login.jsp" class="text-indigo-600 hover:underline font-semibold">Login</a>
      </p>
    </div>
  </div>

</body>
</html>
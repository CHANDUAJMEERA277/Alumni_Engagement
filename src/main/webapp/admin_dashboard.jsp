<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
<%
if (session == null || session.getAttribute("userEmail") == null || !"admin".equals(session.getAttribute("userRole"))) {
    response.sendRedirect("login.jsp");
    return;
}

String adminEmail = (String) session.getAttribute("userEmail");
String adminName = (String) session.getAttribute("userName");

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

int totalStudents = 0;
int totalAlumni = 0;
int totalJobs = 0;
Map<String, Integer> jobsByType = new HashMap<>();
List<Map<String, String>> students = new ArrayList<>();
List<Map<String, String>> alumni = new ArrayList<>();
List<Map<String, String>> announcements = new ArrayList<>();
List<Map<String, String>> activityLogs = new ArrayList<>();

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sample?useSSL=false&serverTimezone=UTC", "root", "chandu@7750");

    // Count students
    ps = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM users WHERE role='student'");
    rs = ps.executeQuery();
    if (rs.next()) totalStudents = rs.getInt("cnt");
    rs.close(); ps.close();

    // Count alumni
    ps = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM users WHERE role='alumni'");
    rs = ps.executeQuery();
    if (rs.next()) totalAlumni = rs.getInt("cnt");
    rs.close(); ps.close();

    // Count jobs by type
    ps = conn.prepareStatement("SELECT type, COUNT(*) AS cnt FROM jobs_posts GROUP BY type");
    rs = ps.executeQuery();
    while (rs.next()) {
        jobsByType.put(rs.getString("type"), rs.getInt("cnt"));
        totalJobs += rs.getInt("cnt");
    }
    rs.close(); ps.close();

    // Fetch student table
    ps = conn.prepareStatement("SELECT name,email,roll_number,grad_year FROM users WHERE role='student'");
    rs = ps.executeQuery();
    while (rs.next()) {
        Map<String, String> s = new HashMap<>();
        s.put("name", rs.getString("name"));
        s.put("email", rs.getString("email"));
        s.put("roll", rs.getString("roll_number"));
        s.put("year", rs.getString("grad_year"));
        students.add(s);
    }
    rs.close(); ps.close();

    // Fetch alumni table
    ps = conn.prepareStatement("SELECT name,email,company,designation FROM users WHERE role='alumni'");
    rs = ps.executeQuery();
    while (rs.next()) {
        Map<String, String> a = new HashMap<>();
        a.put("name", rs.getString("name"));
        a.put("email", rs.getString("email"));
        a.put("company", rs.getString("company"));
        a.put("designation", rs.getString("designation"));
        alumni.add(a);
    }
    rs.close(); ps.close();

    // Fetch latest 5 announcements
    ps = conn.prepareStatement("SELECT message, created_at FROM announcements ORDER BY created_at DESC LIMIT 5");
    rs = ps.executeQuery();
    while (rs.next()) {
        Map<String, String> ann = new HashMap<>();
        ann.put("message", rs.getString("message"));
        ann.put("time", rs.getString("created_at"));
        announcements.add(ann);
    }
    rs.close(); ps.close();

    // Fetch activity logs
    ps = conn.prepareStatement("SELECT user_email, action, created_at FROM activity_logs ORDER BY created_at DESC LIMIT 10");
    rs = ps.executeQuery();
    while (rs.next()) {
        Map<String, String> log = new HashMap<>();
        log.put("user", rs.getString("user_email"));
        log.put("action", rs.getString("action"));
        log.put("time", rs.getString("created_at"));
        activityLogs.add(log);
    }
    rs.close(); ps.close();

} catch (Exception e) {
    e.printStackTrace();
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (ps != null) ps.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Dashboard | Alumni Connect</title>
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-gray-100 min-h-screen flex">

<!-- Left Sidebar -->
<aside class="w-64 bg-white shadow-lg flex flex-col">
    <div class="p-6 bg-indigo-700 text-white text-center font-bold text-xl">Admin Panel</div>
    <nav class="flex-1 p-4 space-y-2">
        <button onclick="showView('dashboard')" class="w-full text-left px-4 py-2 rounded hover:bg-indigo-100">Dashboard</button>
        <button onclick="showView('students')" class="w-full text-left px-4 py-2 rounded hover:bg-indigo-100">Students</button>
        <button onclick="showView('alumni')" class="w-full text-left px-4 py-2 rounded hover:bg-indigo-100">Alumni</button>
        <button onclick="showView('announcements')" class="w-full text-left px-4 py-2 rounded hover:bg-indigo-100">Announcements</button>
        <button onclick="showView('activity')" class="w-full text-left px-4 py-2 rounded hover:bg-indigo-100">Activity Logs</button>
        <a href="LogoutServlet" class="block mt-6 bg-red-500 text-white text-center py-2 rounded hover:bg-red-600">Logout</a>
    </nav>
</aside>

<!-- Main Content -->
<main class="flex-1 p-6">
    <!-- Dashboard View -->
    <div id="dashboard" class="view">
        <h1 class="text-3xl font-bold mb-6">Welcome, <%=adminName%></h1>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
            <div class="bg-white shadow-lg rounded-xl p-6 text-center">
                <h2 class="text-lg font-semibold text-gray-700 mb-2">Total Students</h2>
                <p class="text-3xl font-bold text-indigo-600"><%=totalStudents%></p>
            </div>
            <div class="bg-white shadow-lg rounded-xl p-6 text-center">
                <h2 class="text-lg font-semibold text-gray-700 mb-2">Total Alumni</h2>
                <p class="text-3xl font-bold text-purple-600"><%=totalAlumni%></p>
            </div>
            <div class="bg-white shadow-lg rounded-xl p-6 text-center">
                <h2 class="text-lg font-semibold text-gray-700 mb-2">Total Jobs</h2>
                <p class="text-3xl font-bold text-pink-600"><%=totalJobs%></p>
            </div>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="bg-white p-6 rounded-xl shadow-lg">
                <h2 class="text-xl font-bold mb-4 text-gray-700">Jobs by Type</h2>
                <canvas id="jobsChart"></canvas>
            </div>
            <div class="bg-white p-6 rounded-xl shadow-lg">
                <h2 class="text-xl font-bold mb-4 text-gray-700">Students vs Alumni</h2>
                <canvas id="usersChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Students Table -->
    <div id="students" class="view hidden">
        <h2 class="text-2xl font-bold mb-4">Students</h2>
        <table class="min-w-full bg-white shadow rounded-lg overflow-hidden">
            <thead class="bg-indigo-600 text-white">
                <tr>
                    <th class="px-4 py-2">Name</th>
                    <th class="px-4 py-2">Email</th>
                    <th class="px-4 py-2">Roll No</th>
                    <th class="px-4 py-2">Graduation Year</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String,String> s : students) { %>
                <tr class="border-b">
                    <td class="px-4 py-2"><%=s.get("name")%></td>
                    <td class="px-4 py-2"><%=s.get("email")%></td>
                    <td class="px-4 py-2"><%=s.get("roll")%></td>
                    <td class="px-4 py-2"><%=s.get("year")%></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Alumni Table -->
    <div id="alumni" class="view hidden">
        <h2 class="text-2xl font-bold mb-4">Alumni</h2>
        <table class="min-w-full bg-white shadow rounded-lg overflow-hidden">
            <thead class="bg-purple-600 text-white">
                <tr>
                    <th class="px-4 py-2">Name</th>
                    <th class="px-4 py-2">Email</th>
                    <th class="px-4 py-2">Company</th>
                    <th class="px-4 py-2">Designation</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String,String> a : alumni) { %>
                <tr class="border-b">
                    <td class="px-4 py-2"><%=a.get("name")%></td>
                    <td class="px-4 py-2"><%=a.get("email")%></td>
                    <td class="px-4 py-2"><%=a.get("company")%></td>
                    <td class="px-4 py-2"><%=a.get("designation")%></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Announcements -->
    <div id="announcements" class="view hidden">
        <h2 class="text-2xl font-bold mb-4">Announcements</h2>
        <form action="AnnouncementServlet" method="post" class="mb-4 flex gap-2">
            <input type="text" name="message" placeholder="New announcement..." class="flex-1 px-4 py-2 border rounded-lg">
            <button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded-lg">Post</button>
        </form>
        <input type="text" id="searchAnn" placeholder="Search..." class="mb-4 px-4 py-2 border rounded-lg w-full" onkeyup="filterAnnouncements()">
        <ul id="announcementList" class="space-y-2">
            <% for (Map<String,String> ann : announcements) { %>
            <li class="bg-white p-4 rounded shadow flex justify-between items-center">
                <div><strong><%=ann.get("time")%>:</strong> <%=ann.get("message")%></div>
                <form action="DeleteAnnouncementServlet" method="post" class="ml-4">
                    <input type="hidden" name="time" value="<%=ann.get("time")%>">
                    <button type="submit" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Delete</button>
                </form>
            </li>
            <% } %>
        </ul>
    </div>

    <!-- Activity Logs -->
    <div id="activity" class="view hidden">
        <h2 class="text-2xl font-bold mb-4">Activity Logs</h2>
        <input type="text" id="filterLog" placeholder="Filter by user/action..." class="mb-4 px-4 py-2 border rounded-lg w-full" onkeyup="filterLogs()">
        <div class="overflow-x-auto">
            <table id="activityTable" class="min-w-full bg-white shadow rounded-lg overflow-hidden">
                <thead class="bg-gray-700 text-white">
                    <tr>
                        <th class="px-4 py-2">User Email</th>
                        <th class="px-4 py-2">Action</th>
                        <th class="px-4 py-2">Timestamp</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String,String> log : activityLogs) { %>
                    <tr class="border-b">
                        <td class="px-4 py-2"><%=log.get("user")%></td>
                        <td class="px-4 py-2"><%=log.get("action")%></td>
                        <td class="px-4 py-2"><%=log.get("time")%></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script>
// Sidebar view switching
function showView(viewId){
    const views = document.querySelectorAll('.view');
    views.forEach(v => v.classList.add('hidden'));
    document.getElementById(viewId).classList.remove('hidden');
}

// Announcements filter
function filterAnnouncements(){
    let input = document.getElementById("searchAnn").value.toLowerCase();
    let list = document.getElementById("announcementList").getElementsByTagName("li");
    for(let i=0;i<list.length;i++){
        let text = list[i].innerText.toLowerCase();
        list[i].style.display = text.includes(input) ? "" : "none";
    }
}

// Activity logs filter
function filterLogs(){
    let input = document.getElementById("filterLog").value.toLowerCase();
    let rows = document.getElementById("activityTable").getElementsByTagName("tr");
    for(let i=1;i<rows.length;i++){
        let rowText = rows[i].innerText.toLowerCase();
        rows[i].style.display = rowText.includes(input) ? "" : "none";
    }
}

// Jobs Chart
const jobsCtx = document.getElementById('jobsChart').getContext('2d');
const jobsChart = new Chart(jobsCtx, {
    type:'doughnut',
    data:{
        labels:['Job','Internship'],
        datasets:[{
            data:[<%=jobsByType.getOrDefault("Job",0)%>, <%=jobsByType.getOrDefault("Internship",0)%>],
            backgroundColor:['#ec4899','#f43f5e']
        }]
    }
});

// Users Chart
const usersCtx = document.getElementById('usersChart').getContext('2d');
const usersChart = new Chart(usersCtx, {
    type:'bar',
    data:{
        labels:['Students','Alumni'],
        datasets:[{
            label:'Count',
            data:[<%=totalStudents%>,<%=totalAlumni%>],
            backgroundColor:['#6366f1','#a855f7']
        }]
    },
    options:{scales:{y:{beginAtZero:true}}}
});
</script>

</body>
</html>

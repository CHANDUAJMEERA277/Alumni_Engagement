<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Alumni Connect</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-neutral-950 text-neutral-100">

<!-- NAV -->
<nav class="fixed w-full top-0 z-50 bg-neutral-950/80 backdrop-blur border-b border-neutral-800">
  <div class="max-w-7xl mx-auto flex items-center justify-between px-8 py-5">
    <h1 class="text-2xl font-bold tracking-tight">
      Alumni<span class="text-indigo-500">Connect</span>
    </h1>

    <ul class="hidden md:flex gap-10 text-sm uppercase tracking-wider text-neutral-400">
      <li><a href="#home" class="hover:text-white transition">Home</a></li>
      <li><a href="#about" class="hover:text-white transition">About</a></li>
      <li><a href="#modules" class="hover:text-white transition">Modules</a></li>
      <li><a href="#features" class="hover:text-white transition">Features</a></li>
    </ul>

    <div class="space-x-3">
      <a href="login.jsp"
         class="px-5 py-2 rounded-full border border-neutral-700 hover:border-white transition">
        Login
      </a>
      <a href="signup.jsp"
         class="px-5 py-2 rounded-full bg-white text-black font-semibold hover:scale-105 transition">
        Signup
      </a>
    </div>
  </div>
</nav>

<!-- HERO -->
<section id="home" class="min-h-screen flex items-center justify-center text-center px-6">
  <div class="max-w-4xl">
    <h1 class="text-5xl md:text-7xl font-extrabold leading-tight mb-8">
      Alumni connections,<br>
      <span class="text-indigo-500">reimagined.</span>
    </h1>

    <p class="text-lg md:text-xl text-neutral-400 mb-12">
      A modern platform where students and alumni build careers,
      share opportunities, and grow together.
    </p>

    <div class="flex justify-center gap-6">
      <a href="signup.jsp?role=student"
         class="px-8 py-4 rounded-full bg-indigo-600 hover:bg-indigo-500 transition font-semibold">
        Join as Student
      </a>
      <a href="signup.jsp?role=alumni"
         class="px-8 py-4 rounded-full border border-neutral-700 hover:border-white transition font-semibold">
        Join as Alumni
      </a>
    </div>
  </div>
</section>

<!-- ABOUT -->
<section id="about" class="py-32 px-8 border-t border-neutral-800">
  <div class="max-w-5xl mx-auto grid md:grid-cols-2 gap-16 items-center">
    <h2 class="text-4xl md:text-5xl font-bold">
      Built for real<br>connections.
    </h2>
    <p class="text-neutral-400 text-lg leading-relaxed">
      AlumniConnect helps institutions stay connected with their alumni
      while empowering students through mentorship, referrals, and guidance —
      all in one seamless digital ecosystem.
    </p>
  </div>
</section>

<!-- MODULES -->
<section id="modules" class="py-32 px-8 bg-neutral-900">
  <div class="max-w-6xl mx-auto">
    <h2 class="text-4xl font-bold mb-16">Core Modules</h2>

    <div class="grid md:grid-cols-3 gap-10">
      <div class="p-10 rounded-3xl bg-neutral-950 border border-neutral-800 hover:border-indigo-500 transition">
        <div class="text-4xl mb-6">🎓</div>
        <h3 class="text-2xl font-semibold mb-4">Students</h3>
        <p class="text-neutral-400">
          Find mentors, explore careers, and connect with alumni.
        </p>
      </div>

      <div class="p-10 rounded-3xl bg-neutral-950 border border-neutral-800 hover:border-indigo-500 transition">
        <div class="text-4xl mb-6">💼</div>
        <h3 class="text-2xl font-semibold mb-4">Alumni</h3>
        <p class="text-neutral-400">
          Share opportunities and guide the next generation.
        </p>
      </div>

      <div class="p-10 rounded-3xl bg-neutral-950 border border-neutral-800 hover:border-indigo-500 transition">
        <div class="text-4xl mb-6">⚙️</div>
        <h3 class="text-2xl font-semibold mb-4">Admin</h3>
        <p class="text-neutral-400">
          Control, verify, and manage the entire ecosystem.
        </p>
      </div>
    </div>
  </div>
</section>

<!-- FEATURES -->
<section id="features" class="py-32 px-8">
  <div class="max-w-6xl mx-auto">
    <h2 class="text-4xl font-bold mb-16">What makes it powerful</h2>

    <div class="grid md:grid-cols-3 gap-10">
      <div class="border border-neutral-800 rounded-2xl p-8 hover:border-indigo-500 transition">
        🔍 Smart Alumni Discovery
      </div>
      <div class="border border-neutral-800 rounded-2xl p-8 hover:border-indigo-500 transition">
        💬 Mentorship Requests
      </div>
      <div class="border border-neutral-800 rounded-2xl p-8 hover:border-indigo-500 transition">
        💼 Jobs & Referrals
      </div>
    </div>
  </div>
</section>

<!-- FOOTER -->
<footer class="border-t border-neutral-800 py-10 text-center text-neutral-500">
  © 2025 AlumniConnect
</footer>

</body>
</html>
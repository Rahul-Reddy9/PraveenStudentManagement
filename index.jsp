<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduPulse NexGen | Enterprise Multi-Role ERP & Live Analytics</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');
        body { font-family: 'Inter', sans-serif; transition: background-color 0.3s, color 0.3s; }
        .custom-scrollbar::-webkit-scrollbar { width: 6px; height: 6px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }
        .dark .custom-scrollbar::-webkit-scrollbar-thumb { background: #475569; }
        
        @keyframes scan {
            0% { top: 0%; }
            50% { top: 100%; }
            100% { top: 0%; }
        }
        .scan-line { animation: scan 3s linear infinite; }
    </style>
</head>
<body class="bg-slate-50 text-slate-800 dark:bg-slate-950 dark:text-slate-100 flex h-screen overflow-hidden antialiased transition-colors duration-200">

    <div id="view-login" class="fixed inset-0 bg-slate-900 dark:bg-slate-950 flex items-center justify-center z-50 p-4">
        <div class="bg-white dark:bg-slate-900 w-full max-w-md rounded-2xl shadow-2xl overflow-hidden p-8 space-y-6 border dark:border-slate-800 transition-all">
            <div class="text-center space-y-2">
                <div class="mx-auto w-12 h-12 bg-blue-600 text-white rounded-xl flex items-center justify-center">
                    <i data-lucide="shield-alert" class="w-6 h-6"></i>
                </div>
                <h2 class="text-2xl font-bold text-slate-900 dark:text-white">EduPulse Core Gateway</h2>
                <p class="text-sm text-slate-400 dark:text-slate-500">Security Access Node Infrastructure</p>
            </div>

            <div class="flex bg-slate-100 dark:bg-slate-800 p-1 rounded-xl">
                <button onclick="setLoginRole('admin')" id="tab-admin" class="flex-1 text-center py-2 text-sm font-semibold rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs cursor-pointer">Administration</button>
                <button onclick="setLoginRole('student')" id="tab-student" class="flex-1 text-center py-2 text-sm font-medium rounded-lg text-slate-500 dark:text-slate-400 cursor-pointer">Student Space</button>
            </div>

            <form onsubmit="handleLogin(event)" id="standardLoginForm" class="space-y-4">
                <div>
                    <label id="user-label" class="block text-xs font-semibold text-slate-500 uppercase tracking-wide mb-1.5">Admin Username</label>
                    <input type="text" id="loginUsername" required placeholder="admin or Roll Reference" class="w-full px-3 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-lg uppercase focus:outline-hidden focus:border-blue-500">
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-500 uppercase tracking-wide mb-1.5">Access Password</label>
                    <input type="password" id="loginPassword" required placeholder="••••••••" class="w-full px-3 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 dark:text-white rounded-lg focus:outline-hidden focus:border-blue-500">
                </div>

                <div class="grid grid-cols-2 gap-2 pt-1">
                    <button type="button" onclick="triggerBiometricUI('Face Recognition ID')" class="flex items-center justify-center gap-1.5 py-1.5 border border-slate-200 dark:border-slate-700 rounded-lg text-xs font-medium text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 cursor-pointer">
                        <i data-lucide="scan-face" class="w-3.5 h-3.5 text-blue-500"></i> Face Scan
                    </button>
                    <button type="button" onclick="triggerBiometricUI('Fingerprint Touch ID')" class="flex items-center justify-center gap-1.5 py-1.5 border border-slate-200 dark:border-slate-700 rounded-lg text-xs font-medium text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 cursor-pointer">
                        <i data-lucide="fingerprint" class="w-3.5 h-3.5 text-emerald-500"></i> Touch ID
                    </button>
                </div>

                <div id="credentials-tip" class="p-3 bg-slate-50 dark:bg-slate-800/50 rounded-lg border border-slate-200 dark:border-slate-700 text-xs text-slate-500 space-y-1">
                    <p class="font-semibold text-slate-700 dark:text-slate-300">Default Access Framework:</p>
                    <p id="tip-admin-text">🔑 Admin: <span class="font-mono">admin</span> / <span class="font-mono">admin123</span></p>
                    <p id="tip-student-text" class="hidden">🔑 Student: <span class="font-mono">24951A1269</span> / <span class="font-mono">password123</span></p>
                </div>

                <button type="submit" class="w-full py-2.5 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-lg shadow-xs cursor-pointer">Verify Portal Entry</button>
            </form>

            <div id="biometricScannerUI" class="hidden flex flex-col items-center justify-center py-6 text-center space-y-4">
                <div class="relative w-48 h-48 border-2 border-dashed border-blue-500 rounded-2xl flex items-center justify-center overflow-hidden bg-slate-50 dark:bg-slate-800 shadow-inner">
                    <div class="scan-line absolute left-0 right-0 h-0.5 bg-blue-500 opacity-80 shadow-md z-10"></div>
                    <i id="scanIcon" data-lucide="scan-face" class="w-16 h-16 text-slate-300 animate-pulse z-5"></i>
                </div>
                <div>
                    <h4 id="scanStatusTitle" class="text-sm font-bold text-slate-800 dark:text-white">Connecting Media Pipe Device...</h4>
                    <p class="text-xs text-slate-400 mt-0.5">Please allow camera permissions if prompted</p>
                </div>
                <button onclick="abortScanner()" class="px-3 py-1.5 border border-slate-200 dark:border-slate-700 rounded-lg text-xs font-semibold text-slate-500 hover:bg-slate-50 cursor-pointer">Fallback UI Access</button>
            </div>
        </div>
    </div>

    <div id="app-container" class="w-full h-full flex hidden">
        
        <aside id="app-sidebar" class="w-64 bg-slate-900 text-slate-300 flex flex-col justify-between hidden md:flex border-r border-slate-800">
            <div>
                <div class="p-6 flex items-center gap-3 border-b border-slate-800">
                    <div class="bg-blue-600 text-white p-2 rounded-lg"><i data-lucide="layout-grid" class="w-5 h-5"></i></div>
                    <div>
                        <h1 class="text-white font-black text-lg tracking-tight">EduPulse</h1>
                        <p class="text-[10px] text-slate-500 font-bold tracking-widest uppercase">System Core Matrix</p>
                    </div>
                </div>
                <nav class="p-4 space-y-1.5">
                    <button onclick="switchView('dashboard')" id="nav-dashboard" class="nav-btn w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium bg-blue-600 text-white">
                        <i data-lucide="activity" class="w-4 h-4"></i> Admin Analytics
                    </button>
                    <button onclick="switchView('students')" id="nav-students" class="nav-btn w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium text-slate-400 hover:bg-slate-800 hover:text-slate-200">
                        <i data-lucide="users" class="w-4 h-4"></i> Master Registry
                    </button>
                    <button onclick="switchView('notices')" id="nav-notices" class="nav-btn w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium text-slate-400 hover:bg-slate-800 hover:text-slate-200">
                        <i data-lucide="megaphone" class="w-4 h-4"></i> Terminal Broadcasts
                    </button>
                </nav>
            </div>
            <div class="p-4 border-t border-slate-800 text-xs font-mono font-medium tracking-wider text-slate-600">CLUSTER MODE ACTIVE</div>
        </aside>

        <main class="flex-1 flex flex-col min-w-0 overflow-hidden">
            <header class="h-16 bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-800 flex items-center justify-between px-6 z-10">
                <h2 id="view-title" class="text-lg font-bold text-slate-900 dark:text-white">Loading Node System...</h2>
                <div class="flex items-center gap-3">
                    <button onclick="toggleDarkMode()" class="p-2 text-slate-500 hover:text-slate-800 dark:text-slate-400 dark:hover:text-white border border-slate-200 dark:border-slate-800 rounded-xl bg-slate-50 dark:bg-slate-800 cursor-pointer transition-colors" title="Toggle Display Matrix Scheme">
                        <i data-lucide="sun" id="sunIcon" class="w-4 h-4 hidden"></i>
                        <i data-lucide="moon" id="moonIcon" class="w-4 h-4"></i>
                    </button>
                    <button onclick="logout()" class="flex items-center gap-1.5 px-3 py-1.5 text-xs font-bold border border-slate-200 dark:border-slate-800 rounded-lg text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-950/20 cursor-pointer transition-colors"><i data-lucide="power" class="w-3.5 h-3.5"></i> Exit</button>
                </div>
            </header>

            <div class="flex-1 overflow-y-auto p-6 custom-scrollbar">
                
                <section id="view-dashboard" class="space-y-6 hidden">
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                        <div class="bg-white dark:bg-slate-900 p-5 rounded-xl border border-slate-200 dark:border-slate-800 shadow-xs flex items-center justify-between">
                            <div><p class="text-xs font-bold text-slate-400 uppercase tracking-wide">Total Roll Headcount</p><h3 id="stat-total" class="text-3xl font-black text-slate-900 dark:text-white mt-1">0</h3></div>
                            <div class="p-3 bg-blue-50 text-blue-600 dark:bg-blue-950/40 rounded-lg"><i data-lucide="database" class="w-5 h-5"></i></div>
                        </div>
                        <div class="bg-white dark:bg-slate-900 p-5 rounded-xl border border-slate-200 dark:border-slate-800 shadow-xs flex items-center justify-between">
                            <div><p class="text-xs font-bold text-slate-400 uppercase tracking-wide">Class Attendance Avg</p><h3 id="stat-attendance" class="text-3xl font-black text-slate-900 dark:text-white mt-1">0%</h3></div>
                            <div class="p-3 bg-emerald-50 text-emerald-600 dark:bg-emerald-950/40 rounded-lg"><i data-lucide="trending-up" class="w-5 h-5"></i></div>
                        </div>
                        <div class="bg-white dark:bg-slate-900 p-5 rounded-xl border border-slate-200 dark:border-slate-800 shadow-xs flex items-center justify-between">
                            <div><p class="text-xs font-bold text-slate-400 uppercase tracking-wide">Mean GPA Profile</p><h3 id="stat-gpa" class="text-3xl font-black text-slate-900 dark:text-white mt-1">0.00</h3></div>
                            <div class="p-3 bg-amber-50 text-amber-600 dark:bg-amber-950/40 rounded-lg"><i data-lucide="award" class="w-5 h-5"></i></div>
                        </div>
                        <div class="bg-white dark:bg-slate-900 p-5 rounded-xl border border-slate-200 dark:border-slate-800 shadow-xs flex items-center justify-between">
                            <div><p class="text-xs font-bold text-slate-400 uppercase tracking-wide">Financial Pending Alerts</p><h3 id="stat-fees" class="text-3xl font-black text-slate-900 dark:text-white mt-1">0</h3></div>
                            <div class="p-3 bg-rose-50 text-rose-600 dark:bg-rose-950/40 rounded-lg"><i data-lucide="dollar-sign" class="w-5 h-5"></i></div>
                        </div>
                    </div>
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        <div class="bg-white dark:bg-slate-900 p-5 rounded-xl border border-slate-200 dark:border-slate-800"><h4 class="text-sm font-semibold mb-4">Stream Distribution Split Matrix</h4><div class="h-64"><canvas id="deptChart"></canvas></div></div>
                        <div class="bg-white dark:bg-slate-900 p-5 rounded-xl border border-slate-200 dark:border-slate-800"><h4 class="text-sm font-semibold mb-4">Grade Density Allocation Spread</h4><div class="h-64"><canvas id="gpaChart"></canvas></div></div>
                    </div>
                </section>

                <section id="view-students" class="hidden space-y-4">
                    <div class="flex flex-col sm:flex-row gap-3 justify-between items-center bg-white dark:bg-slate-900 p-4 rounded-xl border border-slate-200 dark:border-slate-800 shadow-xs">
                        <div class="relative flex-1 max-w-md w-full">
                            <i data-lucide="search" class="w-4 h-4 absolute left-3 top-3.5 text-slate-400"></i>
                            <input type="text" id="searchInput" oninput="renderStudentsTable()" placeholder="Query unique roll hash data or profile tags..." class="w-full pl-10 pr-4 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 rounded-lg focus:outline-hidden">
                        </div>
                        <div class="flex items-center gap-2 w-full sm:w-auto justify-end">
                            <button onclick="exportToCSV()" class="flex items-center gap-1.5 px-3 py-2 border border-slate-200 dark:border-slate-700 text-slate-700 dark:text-slate-300 text-sm font-medium rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800 cursor-pointer shadow-xs transition-colors">
                                <i data-lucide="download" class="w-4 h-4 text-emerald-500"></i> Export Sheet
                            </button>
                            <button onclick="openModal('add')" class="bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium px-4 py-2 rounded-lg cursor-pointer flex items-center gap-2 shadow-xs transition-colors"><i data-lucide="plus" class="w-4 h-4"></i> Enroll Student</button>
                        </div>
                    </div>
                    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-xs overflow-hidden">
                        <div class="overflow-x-auto custom-scrollbar">
                            <table class="w-full text-left border-collapse text-sm">
                                <thead>
                                    <tr class="bg-slate-50 dark:bg-slate-800/50 border-b border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400 font-medium">
                                        <th class="p-4">Roll Hash Reference</th><th class="p-4">Student Profile Identity</th><th class="p-4">Branch Stream</th><th class="p-4">GPA Matrix</th><th class="p-4">Lecture Attendance</th><th class="p-4">Financial Clearance</th><th class="p-4 text-right">Actions Matrix</th>
                                    </tr>
                                </thead>
                                <tbody id="studentTableBody" class="divide-y divide-slate-100 dark:divide-slate-800"></tbody>
                            </table>
                        </div>
                    </div>
                </section>

                <section id="view-notices" class="hidden space-y-6">
                    <div class="bg-white dark:bg-slate-900 p-6 rounded-xl border border-slate-200 dark:border-slate-800 shadow-xs max-w-2xl space-y-4">
                        <h3 class="text-sm font-bold uppercase tracking-wider text-slate-400">Publish Academic Directives</h3>
                        <div class="space-y-3">
                            <input type="text" id="noticeTitle" placeholder="Directive Header Classification Title" class="w-full px-3 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 rounded-lg focus:outline-hidden">
                            <textarea id="noticeContent" rows="3" placeholder="Input structural circular broadcast message content data block elements..." class="w-full px-3 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 rounded-lg focus:outline-hidden"></textarea>
                            <button onclick="publishNotice()" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-semibold text-sm rounded-lg shadow-xs cursor-pointer transition-colors">Deploy Channel Broadcast</button>
                        </div>
                    </div>
                    <div class="space-y-3 max-w-2xl">
                        <h4 class="text-xs font-bold text-slate-400 uppercase tracking-widest">Active Server Dispatch Feeds</h4>
                        <div id="adminNoticeFeed" class="space-y-3"></div>
                    </div>
                </section>

                <section id="view-student-portal" class="hidden space-y-6">
                    <div class="bg-linear-to-br from-blue-900 to-slate-950 text-white p-8 rounded-2xl shadow-md flex flex-col lg:flex-row justify-between items-start lg:items-center gap-6 relative border border-slate-800">
                        <div class="space-y-2">
                            <div class="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-blue-500/20 border border-blue-400/30 text-blue-300 text-xs font-bold uppercase tracking-widest">Secure Client Node</div>
                            <h3 id="sProfileName" class="text-3xl font-black tracking-tight">--</h3>
                            <p id="sProfileMeta" class="text-slate-400 text-sm font-mono tracking-wide"></p>
                            
                            <div class="pt-2 flex items-center gap-2">
                                <input type="password" id="sNewPasswordInput" placeholder="Update Account Password" class="px-2.5 py-1 text-xs border border-slate-800 bg-slate-900 text-white rounded-lg focus:outline-hidden max-w-[160px]">
                                <button onclick="updateStudentOwnPassword()" class="px-2.5 py-1 bg-slate-800 hover:bg-slate-700 text-[11px] font-bold rounded-lg cursor-pointer transition-colors">Save Secret</button>
                            </div>
                        </div>
                        
                        <div class="flex items-center gap-4 bg-white/5 p-4 rounded-xl border border-white/10 w-full sm:w-auto">
                            <div id="studentIdQrCanvas" class="bg-white p-1.5 rounded-lg shrink-0"></div>
                            <div>
                                <h4 class="text-xs font-bold uppercase tracking-wider text-blue-400">Digital Access Badge</h4>
                                <p class="text-[10px] text-slate-400 mt-0.5">Encrypted ID Verification Node</p>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="bg-white dark:bg-slate-900 p-6 rounded-xl border border-slate-200 dark:border-slate-800 space-y-4 shadow-xs">
                            <div class="flex justify-between items-center"><h4 class="text-xs font-bold text-slate-400 uppercase tracking-wider">Attendance Quotient</h4><span id="sAttStatus" class="text-xs font-bold"></span></div>
                            <div class="flex items-baseline gap-1"><span id="sAttVal" class="text-4xl font-black text-slate-900 dark:text-white">0%</span></div>
                            <div class="w-full bg-slate-100 dark:bg-slate-800 h-2 rounded-full overflow-hidden"><div id="sAttProgress" class="h-full"></div></div>
                        </div>
                        <div class="bg-white dark:bg-slate-900 p-6 rounded-xl border border-slate-200 dark:border-slate-800 space-y-4 shadow-xs">
                            <div class="flex justify-between items-center"><h4 class="text-xs font-bold text-slate-400 uppercase tracking-wider">Academic Grade Matrix Point</h4><span class="text-[10px] font-bold text-amber-600 bg-amber-50 dark:bg-amber-950/40 px-2 py-0.5 rounded-sm">4.0 Absolute Ceiling Scale</span></div>
                            <div class="flex items-baseline gap-1"><span id="sGpaVal" class="text-4xl font-black text-slate-900 dark:text-white">0.00</span></div>
                            <div class="w-full bg-slate-100 dark:bg-slate-800 h-2 rounded-full overflow-hidden"><div id="sGpaProgress" class="h-full bg-amber-500"></div></div>
                        </div>
                    </div>

                    <div class="bg-linear-to-r from-emerald-900/30 to-teal-900/10 border border-emerald-500/20 p-6 rounded-xl space-y-4">
                        <div class="flex items-center gap-2 text-emerald-400"><i data-lucide="brain-circuit" class="w-5 h-5"></i><h4 class="text-xs font-bold uppercase tracking-wider">AI Predictive Evaluation Projection Hub</h4></div>
                        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 text-sm">
                            <div class="bg-black/20 p-4 rounded-lg"><span class="text-xs text-slate-400 block">Placement Eligibility</span><p id="predictPlacement" class="text-base font-bold mt-1 tracking-wide">--</p></div>
                            <div class="bg-black/20 p-4 rounded-lg"><span class="text-xs text-slate-400 block">Projected Semester Performance</span><p id="predictFinalGrade" class="text-base font-bold mt-1 tracking-wide">--</p></div>
                            <div class="bg-black/20 p-4 rounded-lg"><span class="text-xs text-slate-400 block">System Attrition Risk Level</span><p id="predictRisk" class="text-base font-bold mt-1 tracking-wide">--</p></div>
                        </div>
                    </div>

                    <div class="bg-white dark:bg-slate-900 p-6 rounded-xl border border-slate-200 dark:border-slate-800 space-y-4 max-w-3xl shadow-xs">
                        <div class="flex items-center gap-2 text-slate-900 dark:text-white border-b border-slate-100 dark:border-slate-800 pb-3"><i data-lucide="bell" class="w-4 h-4 text-blue-600"></i><h4 class="font-bold text-sm uppercase tracking-wider">Active Campus Communications Ledger</h4></div>
                        <div id="studentNoticeFeed" class="space-y-4 divide-y divide-slate-100 dark:divide-slate-800 pt-1"></div>
                    </div>
                </section>

            </div>
        </main>
    </div>

    <div id="studentModal" class="fixed inset-0 bg-slate-900/40 backdrop-blur-xs z-50 flex items-center justify-center hidden opacity-0 transition-opacity duration-200">
        <div class="bg-white dark:bg-slate-900 w-full max-w-lg rounded-xl shadow-xl border border-slate-200 dark:border-slate-800 flex flex-col transform scale-95 transition-transform duration-200">
            <div class="p-5 border-b border-slate-100 dark:border-slate-800 flex items-center justify-between"><h3 id="modalTitle" class="text-base font-bold text-slate-900 dark:text-white">Write Target Matrix Object</h3><button onclick="closeModal()" class="text-slate-400 cursor-pointer"><i data-lucide="x" class="w-5 h-5"></i></button></div>
            <form id="studentForm" onsubmit="handleFormSubmit(event)" class="p-5 space-y-4">
                <input type="hidden" id="formAction" value="add">
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Roll Key Reference</label>
                        <input type="text" id="studentRoll" required placeholder="e.g., 24951A1269" class="w-full px-3 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 rounded-lg uppercase focus:outline-hidden">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Secret System Password</label>
                        <input type="text" id="studentPassword" required placeholder="password123" class="w-full px-3 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 rounded-lg focus:outline-hidden">
                    </div>
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Full Name Signature</label>
                    <input type="text" id="studentName" required class="w-full px-3 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 rounded-lg focus:outline-hidden">
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Branch Allocations Matrix Group</label>
                    <select id="studentDept" class="w-full px-3 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 rounded-lg bg-white focus:outline-hidden">
                        <option value="Information Technology">Information Technology</option>
                        <option value="Computer Science">Computer Science</option>
                        <option value="Data Science">Data Science</option>
                        <option value="Cyber Security">Cyber Security</option>
                    </select>
                </div>
                <div class="grid grid-cols-3 gap-4">
                    <div><label class="block text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">GPA Point</label><input type="number" id="studentGPA" required min="0" max="4" step="0.01" class="w-full px-3 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 rounded-lg focus:outline-hidden"></div>
                    <div><label class="block text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Attendance (%)</label><input type="number" id="studentAttendance" required min="0" max="100" class="w-full px-3 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 rounded-lg focus:outline-hidden"></div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Fee Stratum</label>
                        <select id="studentFees" class="w-full px-3 py-2 text-sm border border-slate-200 dark:border-slate-700 dark:bg-slate-800 rounded-lg bg-white focus:outline-hidden">
                            <option value="Paid">Paid</option>
                            <option value="Unpaid">Unpaid</option>
                        </select>
                    </div>
                </div>
                <div class="pt-4 border-t border-slate-100 dark:border-slate-800 flex justify-end gap-2">
                    <button type="button" onclick="closeModal()" class="px-4 py-2 text-sm border border-slate-200 dark:border-slate-700 text-slate-600 rounded-lg cursor-pointer">Abort</button>
                    <button type="submit" class="px-4 py-2 text-sm bg-blue-600 text-white font-medium rounded-lg cursor-pointer shadow-xs">Commit Registry Object</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const initialMockRegistry = [
            { roll: "24951A1201", pass: "password123", name: "Ananya Sharma", dept: "Computer Science", gpa: 3.92, attendance: 96, fees: "Paid" },
            { roll: "24951A1224", pass: "password123", name: "Vikram Malhotra", dept: "Information Technology", gpa: 2.45, attendance: 68, fees: "Unpaid" },
            { roll: "24951A1242", pass: "password123", name: "Priya Nair", dept: "Data Science", gpa: 3.78, attendance: 91, fees: "Paid" },
            { roll: "24951A1269", pass: "password123", name: "Rahul Reddy", dept: "Information Technology", gpa: 3.89, attendance: 94, fees: "Paid" },
            { roll: "24951A1285", pass: "password123", name: "Siddharth Jain", dept: "Cyber Security", gpa: 3.11, attendance: 79, fees: "Unpaid" }
        ];

        const fallbackNotices = [
            { id: 1, title: "Autonomous Semester Project Assessments", text: "Ensure full standalone single code files are checked against validation suites prior to review slots.", date: "Today" },
            { id: 2, title: "Network Core Topology Maintenance Loop", text: "On-campus node services will run at low operational bandwidth profiles over the weekend due to server tuning.", date: "Yesterday" }
        ];

        let students = []; let notices = []; let targetRole = 'admin'; let session = null;
        let chartInstance1 = null; let chartInstance2 = null; let qrInstance = null;
        let activeVideoStream = null;

        document.addEventListener("DOMContentLoaded", () => {
            lucide.createIcons();
            if(!localStorage.getItem("ep_students")) localStorage.setItem("ep_students", JSON.stringify(initialMockRegistry));
            if(!localStorage.getItem("ep_notices")) localStorage.setItem("ep_notices", JSON.stringify(fallbackNotices));
            
            students = JSON.parse(localStorage.getItem("ep_students"));
            notices = JSON.parse(localStorage.getItem("ep_notices"));

            if(localStorage.getItem("ep_darkMode") === "true") toggleDarkMode(true);
        });

        function toggleDarkMode(force = false) {
            const body = document.body;
            const sun = document.getElementById("sunIcon");
            const moon = document.getElementById("moonIcon");
            
            if (force || !body.classList.contains("dark")) {
                body.classList.add("dark"); sun.classList.remove("hidden"); moon.classList.add("hidden");
                localStorage.setItem("ep_darkMode", "true");
            } else {
                body.classList.remove("dark"); moon.classList.remove("hidden"); sun.classList.add("hidden");
                localStorage.setItem("ep_darkMode", "false");
            }
            if(session && session.role === 'admin') renderCharts();
        }

        function setLoginRole(role) {
            targetRole = role;
            const tA = document.getElementById("tab-admin"), tS = document.getElementById("tab-student");
            const tA_txt = document.getElementById("tip-admin-text"), tS_txt = document.getElementById("tip-student-text");
            const userLabel = document.getElementById("user-label");

            if(role === 'admin') {
                tA.className = "flex-1 text-center py-2 text-sm font-semibold rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs cursor-pointer";
                tS.className = "flex-1 text-center py-2 text-sm font-medium rounded-lg text-slate-500 dark:text-slate-400 cursor-pointer";
                tA_txt.classList.remove("hidden"); tS_txt.classList.add("hidden");
                userLabel.innerText = "Admin Username";
            } else {
                tS.className = "flex-1 text-center py-2 text-sm font-semibold rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs cursor-pointer";
                tA.className = "flex-1 text-center py-2 text-sm font-medium rounded-lg text-slate-500 dark:text-slate-400 cursor-pointer";
                tS_txt.classList.remove("hidden"); tA_txt.classList.add("hidden");
                userLabel.innerText = "Student Roll Number";
            }
        }

        // HARDWARE CAPTURE DEVICE STREAMS WITH FULL CONTEXT AUTO LOGINS
        async function triggerBiometricUI(typeTitle) {
            document.getElementById("standardLoginForm").classList.add("hidden");
            const sUI = document.getElementById("biometricScannerUI");
            const sIcon = document.getElementById("scanIcon");
            sUI.classList.remove("hidden");
            
            document.getElementById("scanStatusTitle").innerText = `Connecting Hardware WebCam Lens...`;
            
            let videoEl = document.getElementById("webcamPreviewNode");
            if(!videoEl) {
                videoEl = document.createElement("video");
                videoEl.id = "webcamPreviewNode";
                videoEl.className = "absolute inset-0 w-full h-full object-cover rounded-2xl z-0";
                videoEl.setAttribute("autoplay", "true");
                videoEl.setAttribute("playsinline", "true");
                sIcon.parentElement.appendChild(videoEl);
            }
            
            sIcon.classList.remove("hidden");
            videoEl.classList.add("hidden");

            try {
                activeVideoStream = await navigator.mediaDevices.getUserMedia({ 
                    video: { width: 300, height: 300, facingMode: "user" } 
                });
                
                videoEl.srcObject = activeVideoStream;
                videoEl.classList.remove("hidden");
                sIcon.classList.add("hidden");
                document.getElementById("scanStatusTitle").innerText = `Running Secure Matrix Verification Match...`;
                
                setTimeout(() => {
                    if(!activeVideoStream) return;
                    if(targetRole === 'admin') {
                        session = { role: 'admin' };
                    } else {
                        session = { role: 'student', profile: students.find(s => s.roll === "24951A1269") };
                    }
                    abortScanner(); bootSystem();
                }, 3500);

            } catch (err) {
                console.error("Camera linkage block initialization failure error:", err);
                document.getElementById("scanStatusTitle").innerText = "WebCam Link Blocked or Unavailable";
                alert("Authorization Core Refused: Please verify browser permission rules for your hardware webcam, or execute password standard auth lines.");
                abortScanner();
            }
        }

        function abortScanner() {
            if(activeVideoStream) {
                activeVideoStream.getTracks().forEach(track => track.stop());
                activeVideoStream = null;
            }
            const videoEl = document.getElementById("webcamPreviewNode");
            if(videoEl) videoEl.remove();
            
            document.getElementById("biometricScannerUI").classList.add("hidden");
            document.getElementById("standardLoginForm").classList.remove("hidden");
        }

        function handleLogin(e) {
            e.preventDefault();
            const u = document.getElementById("loginUsername").value.trim().toUpperCase();
            const p = document.getElementById("loginPassword").value;

            if(targetRole === 'admin') {
                if(u === 'ADMIN' && p === 'admin123') { session = { role: 'admin' }; bootSystem(); }
                else { alert("Invalid administration credential mappings matching security database tables."); }
            } else {
                const sMatch = students.find(s => s.roll === u && s.pass === p);
                if(sMatch) { session = { role: 'student', profile: sMatch }; bootSystem(); }
                else { alert("Identity verification failed. Match criteria roll key matrix not found."); }
            }
        }

        function bootSystem() {
            document.getElementById("view-login").classList.add("hidden");
            document.getElementById("app-container").classList.remove("hidden");
            if(session.role === 'admin') {
                document.getElementById("app-sidebar").classList.remove("hidden"); switchView('dashboard');
            } else {
                document.getElementById("app-sidebar").classList.add("hidden"); switchView('student-portal');
            }
        }

        function logout() {
            session = null;
            document.getElementById("app-container").classList.add("hidden");
            document.getElementById("view-login").classList.remove("hidden");
            document.getElementById("loginPassword").value = "";
        }

        function switchView(viewId) {
            ['dashboard','students','notices','student-portal'].forEach(id => document.getElementById(`view-${id}`).classList.add("hidden"));
            document.querySelectorAll(".nav-btn").forEach(b => b.className = "nav-btn w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium text-slate-400 hover:bg-slate-800");
            
            document.getElementById(`view-${viewId}`).classList.remove("hidden");
            
            if(viewId === 'dashboard') {
                document.getElementById("nav-dashboard").className = "nav-btn w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium bg-blue-600 text-white";
                document.getElementById("view-title").innerText = "Executive Operations Overview Matrix";
                calculateMetrics(); renderCharts();
            } else if(viewId === 'students') {
                document.getElementById("nav-students").className = "nav-btn w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium bg-blue-600 text-white";
                document.getElementById("view-title").innerText = "Master Ledger Node Controller";
                renderStudentsTable();
            } else if(viewId === 'notices') {
                document.getElementById("nav-notices").className = "nav-btn w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium bg-blue-600 text-white";
                document.getElementById("view-title").innerText = "Directive Communications Terminal Channel";
                renderAdminNotices();
            } else if(viewId === 'student-portal') {
                document.getElementById("view-title").innerText = "Student Self-Service Console View";
                renderStudentPortalMetrics(session.profile);
            }
        }

        function exportToCSV() {
            let csvContent = "data:text/csv;charset=utf-8,Roll ID,Name,Department,GPA,Attendance,Fees\n";
            students.forEach(s => { csvContent += `${s.roll},${s.name},${s.dept},${s.gpa},${s.attendance}%,${s.fees}\n`; });
            const encodedUri = encodeURI(csvContent);
            const link = document.createElement("a");
            link.setAttribute("href", encodedUri); link.setAttribute("download", `Master_Student_Registry_Report.csv`);
            document.body.appendChild(link); link.click(); document.body.removeChild(link);
        }

        function updateStudentOwnPassword() {
            const newPass = document.getElementById("sNewPasswordInput").value.trim();
            if(!newPass) { alert("Missing security input values framework settings."); return; }
            const idx = students.findIndex(s => s.roll === session.profile.roll);
            if(idx !== -1) {
                students[idx].pass = newPass; localStorage.setItem("ep_students", JSON.stringify(students));
                alert("Account verification secret keys updated safely inside core nodes.");
                document.getElementById("sNewPasswordInput").value = "";
            }
        }

        function calculateMetrics() {
            document.getElementById("stat-total").innerText = students.length;
            document.getElementById("stat-attendance").innerText = `${(students.reduce((acc, c) => acc + parseFloat(c.attendance), 0) / students.length).toFixed(0)}%`;
            document.getElementById("stat-gpa").innerText = (students.reduce((acc, c) => acc + parseFloat(c.gpa), 0) / students.length).toFixed(2);
            document.getElementById("stat-fees").innerText = students.filter(s => s.fees === 'Unpaid').length;
        }

        function renderStudentsTable() {
            const body = document.getElementById("studentTableBody"); const query = document.getElementById("searchInput").value.toLowerCase();
            body.innerHTML = "";
            students.filter(s => s.name.toLowerCase().includes(query) || s.roll.toLowerCase().includes(query)).forEach(s => {
                const tr = document.createElement("tr"); tr.className = "hover:bg-slate-50 dark:hover:bg-slate-800/40 border-b border-slate-100 dark:border-slate-800 text-slate-700 dark:text-slate-300";
                tr.innerHTML = `
                    <td class="p-4 font-mono font-bold text-blue-600 dark:text-blue-400">${s.roll}</td>
                    <td class="p-4 font-semibold text-slate-900 dark:text-white">${s.name}</td>
                    <td class="p-4 text-slate-500">${s.dept}</td>
                    <td class="p-4"><span class="px-2 py-0.5 text-xs font-bold bg-slate-100 dark:bg-slate-800 rounded-sm">${parseFloat(s.gpa).toFixed(2)}</span></td>
                    <td class="p-4 font-medium">${s.attendance}%</td>
                    <td class="p-4"><span class="px-2.5 py-1 rounded-md text-xs font-bold ${s.fees === 'Paid'?'bg-emerald-50 dark:bg-emerald-950/30 text-emerald-700':'bg-rose-50 dark:bg-rose-950/30 text-rose-700'}">${s.fees}</span></td>
                    <td class="p-4 text-right space-x-1">
                        <button onclick="openModal('edit', '${s.roll}')" class="p-1 text-blue-500 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-md cursor-pointer inline-block"><i data-lucide="edit-3" class="w-4 h-4"></i></button>
                        <button onclick="deleteStudent('${s.roll}')" class="p-1 text-rose-500 hover:bg-rose-950/30 rounded-md cursor-pointer inline-block"><i data-lucide="trash-2" class="w-4 h-4"></i></button>
                    </td>
                `;
                body.appendChild(tr);
            });
            lucide.createIcons();
        }

        function renderStudentPortalMetrics(student) {
            const f = students.find(s => s.roll === student.roll) || student;
            document.getElementById("sProfileName").innerText = f.name;
            document.getElementById("sProfileMeta").innerText = `Roll Index: ${f.roll} | Allocation Stack: Dept of ${f.dept}`;
            
            document.getElementById("sAttVal").innerText = `${f.attendance}%`;
            document.getElementById("sAttProgress").style.width = `${f.attendance}%`;
            document.getElementById("sAttProgress").className = f.attendance >= 75 ? "h-full bg-emerald-500" : "h-full bg-rose-500";
            document.getElementById("sAttStatus").innerText = f.attendance >= 75 ? "Lecture Threshold Cleared" : "Warning: Clearance Status Failure Risk Alert";
            document.getElementById("sAttStatus").className = f.attendance >= 75 ? "text-xs font-semibold text-emerald-500" : "text-xs font-semibold text-rose-500";

            document.getElementById("sGpaVal").innerText = parseFloat(f.gpa).toFixed(2);
            document.getElementById("sGpaProgress").style.width = `${(f.gpa / 4) * 100}%`;

            const elPlacement = document.getElementById("predictPlacement");
            const elGrade = document.getElementById("predictFinalGrade");
            const elRisk = document.getElementById("predictRisk");

            if (f.gpa >= 3.5 && f.attendance >= 85) {
                elPlacement.innerText = "Highly Eligible (Tier-1 Core Units)"; elPlacement.className = "text-base font-bold text-emerald-500 mt-1";
                elGrade.innerText = "Projected Distinction (A+)";
                elRisk.innerText = "Negligible (Stable Profile)"; elRisk.className = "text-base font-bold text-slate-400 mt-1";
            } else if (f.gpa >= 3.0 && f.attendance >= 75) {
                elPlacement.innerText = "Eligible (Standard Tech Blocks)"; elPlacement.className = "text-base font-bold text-blue-500 mt-1";
                elGrade.innerText = "Projected Grade First Class (B/A)";
                elRisk.innerText = "Low Control Profile"; elRisk.className = "text-base font-bold text-slate-400 mt-1";
            } else {
                elPlacement.innerText = "Conditional Review Status"; elPlacement.className = "text-base font-bold text-amber-500 mt-1";
                elGrade.innerText = "Projected Clearance (C/D)";
                elRisk.innerText = "High Risk (Critical Intervention)"; elRisk.className = "text-base font-bold text-rose-500 mt-1";
            }

            const qrBox = document.getElementById("studentIdQrCanvas"); qrBox.innerHTML = "";
            if(qrInstance) qrInstance = null;
            qrInstance = new QRCode(qrBox, { text: `EDUPULSE_ID_${f.roll}_${f.name.replace(/\s+/g, '')}`, width: 70, height: 70, correctLevel: QRCode.CorrectLevel.M });

            const sFeed = document.getElementById("studentNoticeFeed"); sFeed.innerHTML = "";
            notices.forEach(n => {
                const d = document.createElement("div"); d.className = "pt-3 first:pt-0 text-slate-700 dark:text-slate-300";
                d.innerHTML = `<span class="text-[9px] font-bold text-blue-500 tracking-widest block uppercase">${n.date}</span><h5 class="text-sm font-bold text-slate-900 dark:text-white mt-0.5">${n.title}</h5><p class="text-xs text-slate-400 mt-1">${n.text}</p>`;
                sFeed.appendChild(d);
            });
        }

        function renderAdminNotices() {
            const feed = document.getElementById("adminNoticeFeed"); feed.innerHTML = "";
            notices.forEach(n => {
                const div = document.createElement("div"); div.className = "bg-white dark:bg-slate-900 p-4 rounded-xl border border-slate-200 dark:border-slate-800 flex justify-between items-start";
                div.innerHTML = `<div><h5 class="font-bold text-sm text-slate-900 dark:text-white">${n.title}</h5><p class="text-xs text-slate-400 mt-1">${n.text}</p></div><button onclick="purgeNotice(${n.id})" class="p-1 text-slate-400 hover:text-rose-500 cursor-pointer"><i data-lucide="trash" class="w-4 h-4"></i></button>`;
                feed.appendChild(div);
            });
            lucide.createIcons();
        }

        function publishNotice() {
            const title = document.getElementById("noticeTitle").value.trim(); const text = document.getElementById("noticeContent").value.trim();
            if(!title || !text) return;
            notices.unshift({ id: Date.now(), title, text, date: "Just now" });
            localStorage.setItem("ep_notices", JSON.stringify(notices));
            document.getElementById("noticeTitle").value = ""; document.getElementById("noticeContent").value = "";
            renderAdminNotices();
        }

        function purgeNotice(id) {
            notices = notices.filter(n => n.id !== id); localStorage.setItem("ep_notices", JSON.stringify(notices)); renderAdminNotices();
        }

        function openModal(action, roll = null) {
            const m = document.getElementById("studentModal"); document.getElementById("formAction").value = action;
            if(action === 'add') {
                document.getElementById("modalTitle").innerText = "Register New Asset Record Profile";
                document.getElementById("studentRoll").disabled = false; document.getElementById("studentForm").reset();
                document.getElementById("studentPassword").value = "password123";
            } else {
                document.getElementById("modalTitle").innerText = "Edit Config Index Parameters";
                const match = students.find(s => s.roll === roll);
                if(match) {
                    document.getElementById("studentRoll").value = match.roll; document.getElementById("studentRoll").disabled = true;
                    document.getElementById("studentPassword").value = match.pass || "password123";
                    document.getElementById("studentName").value = match.name; document.getElementById("studentDept").value = match.dept;
                    document.getElementById("studentGPA").value = match.gpa; document.getElementById("studentAttendance").value = match.attendance;
                    document.getElementById("studentFees").value = match.fees;
                }
            }
            m.classList.remove("hidden");
            setTimeout(() => { m.classList.remove("opacity-0"); m.firstElementChild.classList.remove("scale-95"); }, 5);
        }

        function closeModal() {
            const m = document.getElementById("studentModal"); m.classList.add("opacity-0"); m.firstElementChild.classList.add("scale-95");
            setTimeout(() => m.classList.add("hidden"), 200);
        }

        function handleFormSubmit(e) {
            e.preventDefault();
            const action = document.getElementById("formAction").value;
            const roll = document.getElementById("studentRoll").value.trim().toUpperCase();
            const pass = document.getElementById("studentPassword").value;
            const name = document.getElementById("studentName").value.trim(); const dept = document.getElementById("studentDept").value;
            const gpa = parseFloat(document.getElementById("studentGPA").value); const attendance = parseInt(document.getElementById("studentAttendance").value);
            const fees = document.getElementById("studentFees").value;

            if(action === 'add') {
                if(students.some(s => s.roll === roll)) { alert("Data collision: Primary Roll Index Key already claimed."); return; }
                students.push({ roll, pass, name, dept, gpa, attendance, fees });
            } else {
                const i = students.findIndex(s => s.roll === roll);
                if(i !== -1) students[i] = { roll, pass, name, dept, gpa, attendance, fees };
            }
            localStorage.setItem("ep_students", JSON.stringify(students));
            renderStudentsTable(); closeModal();
        }

        function deleteStudent(roll) {
            if(confirm(`Erase target object signature match index roll identifier references [${roll}]?`)) {
                students = students.filter(s => s.roll !== roll); localStorage.setItem("ep_students", JSON.stringify(students)); renderStudentsTable();
            }
        }

        function renderCharts() {
            const isDark = document.body.classList.contains("dark");
            const textPaletteColor = isDark ? "#94a3b8" : "#475569";
            const borderGridColor = isDark ? "#334155" : "#e2e8f0";

            const dCounts = {}; students.forEach(s => dCounts[s.dept] = (dCounts[s.dept] || 0) + 1);
            let ranges = { "3.5+ [Excellent]": 0, "3.0-3.5 [Competent]": 0, "<3.0 [Action Required]": 0 };
            students.forEach(s => {
                if(s.gpa >= 3.5) ranges["3.5+ [Excellent]"]++;
                else if(s.gpa >= 3.0) ranges["3.0-3.5 [Competent]"]++;
                else ranges["<3.0 [Action Required]"]++;
            });

            if (chartInstance1) chartInstance1.destroy(); if (chartInstance2) chartInstance2.destroy();

            chartInstance1 = new Chart(document.getElementById('deptChart').getContext('2d'), {
                type: 'doughnut',
                data: { labels: Object.keys(dCounts), datasets: [{ data: Object.values(dCounts), backgroundColor: ['#2563eb', '#10b981', '#f59e0b', '#8b5cf6'], borderColor: isDark ? '#1e293b' : '#fff' }] },
                options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom', labels: { color: textPaletteColor } } } }
            });

            chartInstance2 = new Chart(document.getElementById('gpaChart').getContext('2d'), {
                type: 'bar',
                data: { labels: Object.keys(ranges), datasets: [{ label: 'Headcount Density', data: Object.values(ranges), backgroundColor: ['#10b981', '#f59e0b', '#ef4444'], borderRadius: 4 }] },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { labels: { color: textPaletteColor } } },
                    scales: {
                        x: { grid: { color: borderGridColor }, ticks: { color: textPaletteColor } },
                        y: { grid: { color: borderGridColor }, ticks: { color: textPaletteColor, stepSize: 1 } }
                    }
                }
            });
        }
    </script>
</body>
</html>
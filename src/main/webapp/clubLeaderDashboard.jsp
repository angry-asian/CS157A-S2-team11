<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Leader Dashboard — FindMyClub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/styling.css">
</head>
<body>

<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/app/search">Find<span>My</span>Club</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/app/search">Browse Clubs</a>
        <a href="${pageContext.request.contextPath}/app/messages">💬 Messages</a>
        <a href="${pageContext.request.contextPath}/app/savedEvents">⭐ Saved Events</a>
        <span class="nav-user">👋 ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/app/logout">Log Out</a>
    </div>
</nav>

<div class="dash-header">
    <h1>Club Leader Dashboard</h1>
    <p>Manage your clubs, review membership requests, and update club information.</p>
</div>

<div class="container">
    <!-- Flash Messages -->
    <c:if test="${flashMsg == 'created'}">
        <div class="alert alert-success mt-2">✅ Club created! Pending admin approval.</div>
    </c:if>
    <c:if test="${flashMsg == 'updated'}">
        <div class="alert alert-success mt-2">✅ Club updated successfully.</div>
    </c:if>
    <c:if test="${flashMsg == 'approved'}">
        <div class="alert alert-success mt-2">✅ Membership request approved.</div>
    </c:if>
    <c:if test="${flashMsg == 'rejected'}">
        <div class="alert alert-info mt-2">Request rejected.</div>
    </c:if>
    <c:if test="${flashMsg == 'eventCreated'}">
        <div class="alert alert-success mt-2">✅ Event created.</div>
    </c:if>
    <c:if test="${flashMsg == 'eventUpdated'}">
        <div class="alert alert-success mt-2">✅ Event updated.</div>
    </c:if>
    <c:if test="${flashMsg == 'eventDeleted'}">
        <div class="alert alert-info mt-2">Event deleted.</div>
    </c:if>
    <c:if test="${flashMsg == 'eventDenied'}">
        <div class="alert alert-danger mt-2">⚠ You can only manage events for clubs you lead.</div>
    </c:if>
    <c:if test="${flashMsg == 'eventBadInput'}">
        <div class="alert alert-danger mt-2">⚠ Please fill in a title and a valid date/time.</div>
    </c:if>
    <c:if test="${flashMsg == 'eventConflict'}">
        <div class="alert alert-danger mt-2">⚠ This club already has another event within an hour of that time. Pick a different slot.</div>
    </c:if>
    <c:if test="${flashMsg == 'memberRemoved'}">
        <div class="alert alert-info mt-2">Member removed from club.</div>
    </c:if>
    <c:if test="${flashMsg == 'memberDenied'}">
        <div class="alert alert-danger mt-2">⚠ Could not remove that member.</div>
    </c:if>

    <div class="dash-grid">

        <!-- My Clubs Section -->
        <div class="dash-section">
            <h2>🏛 My Clubs</h2>
            <c:choose>
                <c:when test="${empty myClubs}">
                    <p class="text-muted">You haven't created any clubs yet.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="entry" items="${myClubsWithMembers}">
                        <c:set var="club"    value="${entry.club}" />
                        <c:set var="members" value="${entry.members}" />
                        <div class="request-row" style="flex-direction:column;align-items:stretch;gap:.5rem">
                            <div style="display:flex;justify-content:space-between;align-items:center;gap:.6rem">
                                <div class="request-info">
                                    <div class="club-name">${club.name}</div>
                                    <div class="req-meta">${club.category} · ${club.memberCount} members</div>
                                </div>
                                <div style="display:flex;gap:.4rem;align-items:center">
                                    <span class="status-badge status-${club.status}">${club.status}</span>
                                    <button class="btn-outline btn-sm"
                                            onclick="openEdit(${club.id},'${club.description}','${club.meetingLocation}','${club.meetingTime}','${club.communicationPlatform}')">Edit</button>
                                    <a href="${pageContext.request.contextPath}/app/club?id=${club.id}" class="btn-gold btn-sm">View</a>
                                </div>
                            </div>
                            <details class="member-roster">
                                <summary>👥 Members (${members.size()})</summary>
                                <c:choose>
                                    <c:when test="${empty members}">
                                        <p class="text-muted" style="margin:.5rem 0 0">No members yet besides you.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <ul class="member-list">
                                            <c:forEach var="m" items="${members}">
                                                <li>
                                                    <span>${m.name} <span class="text-muted">· ${m.email}</span></span>
                                                    <form action="${pageContext.request.contextPath}/app/removeMember" method="post"
                                                          onsubmit="return confirm('Remove ${m.name} from ${club.name}?')"
                                                          style="margin:0">
                                                        <input type="hidden" name="clubId"   value="${club.id}">
                                                        <input type="hidden" name="memberId" value="${m.id}">
                                                        <button type="submit" class="btn-danger btn-sm">Remove</button>
                                                    </form>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:otherwise>
                                </c:choose>
                            </details>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pending Requests Section -->
        <div class="dash-section">
            <h2>📬 Pending Requests
                <c:if test="${not empty pendingRequests}">
                    <span style="background:var(--red);color:#fff;border-radius:20px;padding:.1rem .5rem;font-size:.75rem">${pendingRequests.size()}</span>
                </c:if>
            </h2>
            <c:choose>
                <c:when test="${empty pendingRequests}">
                    <p class="text-muted">No pending requests.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${pendingRequests}">
                        <c:set var="req" value="${item.request}" />
                        <c:set var="student" value="${item.student}" />
                        <c:set var="club" value="${item.club}" />
                        <div class="request-row" style="flex-direction:column;align-items:flex-start;gap:.5rem">
                            <div>
                                <div class="club-name">${student != null ? student.name : 'Unknown'}</div>
                                <div class="req-meta">Wants to join <strong>${club.name}</strong> · ${req.formattedRequestDate}</div>
                            </div>
                            <div style="display:flex;gap:.5rem">
                                <form action="${pageContext.request.contextPath}/app/processRequest" method="post" style="margin:0">
                                    <input type="hidden" name="requestId" value="${req.id}">
                                    <input type="hidden" name="decision" value="approved">
                                    <button type="submit" class="btn-success btn-sm">✔ Approve</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/app/processRequest" method="post" style="margin:0">
                                    <input type="hidden" name="requestId" value="${req.id}">
                                    <input type="hidden" name="decision" value="rejected">
                                    <button type="submit" class="btn-danger btn-sm">✘ Reject</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Past Requests Section -->
        <div class="dash-section">
            <h2>📜 Request History
                <c:if test="${not empty pastRequests}">
                    <span style="background:var(--gray-300);color:#000;border-radius:20px;padding:.1rem .5rem;font-size:.75rem">${pastRequests.size()}</span>
                </c:if>
            </h2>
            <c:choose>
                <c:when test="${empty pastRequests}">
                    <p class="text-muted">No past requests yet.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${pastRequests}">
                        <c:set var="req"     value="${item.request}" />
                        <c:set var="student" value="${item.student}" />
                        <c:set var="club"    value="${item.club}" />
                        <div class="request-row">
                            <div class="request-info">
                                <div class="club-name">${student != null ? student.name : 'Unknown'}</div>
                                <div class="req-meta">${club.name} · ${req.formattedRequestDate}</div>
                            </div>
                            <span class="status-badge status-${req.status}">${req.status}</span>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- My Events Section -->
        <div class="dash-section">
            <h2>📅 My Events
                <c:if test="${not empty myEvents}">
                    <span style="background:var(--gray-300);color:#000;border-radius:20px;padding:.1rem .5rem;font-size:.75rem">${myEvents.size()}</span>
                </c:if>
            </h2>
            <c:choose>
                <c:when test="${empty myEvents}">
                    <p class="text-muted">No events yet. Use the form below to create one.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${myEvents}">
                        <c:set var="event" value="${item.event}" />
                        <c:set var="club"  value="${item.club}" />
                        <div class="request-row" style="flex-direction:column;align-items:flex-start;gap:.5rem">
                            <div class="request-info" style="width:100%">
                                <div class="club-name">📌 ${event.title}</div>
                                <div class="req-meta">${club.name} · 📅 ${event.formattedDate}</div>
                                <div class="req-meta">📍 ${event.location}</div>
                                <c:if test="${not empty event.description}">
                                    <div class="req-meta" style="margin-top:.3rem">${event.description}</div>
                                </c:if>
                            </div>
                            <div style="display:flex;gap:.4rem">
                                <button type="button" class="btn-outline btn-sm"
                                        data-event-id="${event.id}"
                                        data-title="<c:out value='${event.title}'/>"
                                        data-description="<c:out value='${event.description}'/>"
                                        data-location="<c:out value='${event.location}'/>"
                                        data-event-date="${event.inputDate}"
                                        onclick="openEditEvent(this)">Edit</button>
                                <form action="${pageContext.request.contextPath}/app/deleteEvent" method="post"
                                      onsubmit="return confirm('Delete this event? This cannot be undone.')"
                                      style="margin:0">
                                    <input type="hidden" name="eventId" value="${event.id}">
                                    <button type="submit" class="btn-danger btn-sm">Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Create New Club Section -->
        <div class="dash-section full-width">
            <h2>➕ Create New Club</h2>
            <form action="${pageContext.request.contextPath}/app/createClub" method="post"
                  style="display:grid;grid-template-columns:1fr 1fr;gap:1rem">
                <div class="form-group">
                    <label>Club Name *</label>
                    <input type="text" name="name" placeholder="e.g. Robotics Club" required>
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <select name="category">
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}">${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>Meeting Location</label>
                    <input type="text" name="meetingLocation" placeholder="e.g. Engineering Hall 210">
                </div>
                <div class="form-group">
                    <label>Meeting Time</label>
                    <input type="text" name="meetingTime" placeholder="e.g. Thursdays 5–7 PM">
                </div>
                <div class="form-group">
                    <label>Communication Platform</label>
                    <input type="text" name="communicationPlatform" placeholder="e.g. Discord, Slack">
                </div>
                <div class="form-group" style="grid-column:1/-1">
                    <label>Description</label>
                    <textarea name="description" placeholder="Describe your club's purpose and activities…"></textarea>
                </div>
                <div style="grid-column:1/-1">
                    <button type="submit" class="btn-gold">Submit for Approval</button>
                    <p class="text-muted mt-1">New clubs require admin approval before appearing in search.</p>
                </div>
            </form>
        </div>

        <!-- Create Event Section -->
        <div class="dash-section full-width">
            <h2>➕ Create Event</h2>
            <c:choose>
                <c:when test="${empty myClubs}">
                    <p class="text-muted">Create a club first — events have to be attached to a club you lead.</p>
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/app/createEvent" method="post"
                          style="display:grid;grid-template-columns:1fr 1fr;gap:1rem">
                        <div class="form-group">
                            <label>Club *</label>
                            <select name="clubId" required>
                                <c:forEach var="club" items="${myClubs}">
                                    <option value="${club.id}">${club.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Event Title *</label>
                            <input type="text" name="title" placeholder="e.g. Spring Tournament" required>
                        </div>
                        <div class="form-group">
                            <label>Date &amp; Time *</label>
                            <input type="datetime-local" name="eventDate" required>
                        </div>
                        <div class="form-group">
                            <label>Location</label>
                            <input type="text" name="location" placeholder="e.g. Engineering Hall 210">
                        </div>
                        <div class="form-group" style="grid-column:1/-1">
                            <label>Description</label>
                            <textarea name="description" placeholder="Tell members what to expect…"></textarea>
                        </div>
                        <div style="grid-column:1/-1">
                            <button type="submit" class="btn-gold">Create Event</button>
                            <p class="text-muted mt-1">New events appear immediately on your club's page.</p>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Other Club Leaders -->
        <div class="dash-section full-width">
            <h2>🤝 Other Club Leaders</h2>
            <p class="text-muted" style="margin-bottom:.6rem">Reach out to coordinate events or share resources.</p>
            <c:choose>
                <c:when test="${empty otherLeaders}">
                    <p class="text-muted">No other club leaders yet.</p>
                </c:when>
                <c:otherwise>
                    <ul class="leader-list">
                        <c:forEach var="ldr" items="${otherLeaders}">
                            <li>
                                <span><strong>${ldr.name}</strong> <span class="text-muted">· ${ldr.email}</span></span>
                                <a class="btn-outline btn-sm"
                                   href="${pageContext.request.contextPath}/app/messages?to=${ldr.id}">💬 Message</a>
                            </li>
                        </c:forEach>
                    </ul>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</div>

<!-- Edit Event Modal -->
<div class="modal-overlay" id="editEventModal">
    <div class="modal">
        <h2>Edit Event</h2>
        <form action="${pageContext.request.contextPath}/app/updateEvent" method="post">
            <input type="hidden" name="eventId" id="editEventId">
            <div class="form-group">
                <label>Title</label>
                <input type="text" name="title" id="editEventTitle" required>
            </div>
            <div class="form-group">
                <label>Date &amp; Time</label>
                <input type="datetime-local" name="eventDate" id="editEventDate" required>
            </div>
            <div class="form-group">
                <label>Location</label>
                <input type="text" name="location" id="editEventLocation">
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" id="editEventDesc"></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-outline" onclick="closeEditEvent()">Cancel</button>
                <button type="submit" class="btn-gold">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <h2>Edit Club Info</h2>
        <form action="${pageContext.request.contextPath}/app/updateClub" method="post">
            <input type="hidden" name="clubId" id="editId">
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" id="editDesc"></textarea>
            </div>
            <div class="form-group">
                <label>Meeting Location</label>
                <input type="text" name="meetingLocation" id="editLoc">
            </div>
            <div class="form-group">
                <label>Meeting Time</label>
                <input type="text" name="meetingTime" id="editTime">
            </div>
            <div class="form-group">
                <label>Communication Platform</label>
                <input type="text" name="communicationPlatform" id="editComm">
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-outline" onclick="closeEdit()">Cancel</button>
                <button type="submit" class="btn-gold">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script>
function openEdit(id, desc, loc, time, comm) {
    document.getElementById('editId').value   = id;
    document.getElementById('editDesc').value = desc;
    document.getElementById('editLoc').value  = loc;
    document.getElementById('editTime').value = time;
    document.getElementById('editComm').value = comm;
    document.getElementById('editModal').classList.add('open');
}

function closeEdit() {
    document.getElementById('editModal').classList.remove('open');
}

document.getElementById('editModal').addEventListener('click', function(e) {
    if (e.target === this) closeEdit();
});

function openEditEvent(btn) {
    document.getElementById('editEventId').value       = btn.dataset.eventId;
    document.getElementById('editEventTitle').value    = btn.dataset.title;
    document.getElementById('editEventDate').value     = btn.dataset.eventDate;
    document.getElementById('editEventLocation').value = btn.dataset.location;
    document.getElementById('editEventDesc').value     = btn.dataset.description;
    document.getElementById('editEventModal').classList.add('open');
}

function closeEditEvent() {
    document.getElementById('editEventModal').classList.remove('open');
}

document.getElementById('editEventModal').addEventListener('click', function(e) {
    if (e.target === this) closeEditEvent();
});
</script>

</body>
</html>
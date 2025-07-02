<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Coupon Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <style>
        .expired { background-color: #f8d7da; }
        .inactive { background-color: #d1ecf1; }
        .limit-reached { background-color: #fff3cd; }
        .valid { background-color: #d4edda; }
        .status-badge {
            font-size: 0.8em;
            padding: 4px 8px;
            border-radius: 12px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-12">
                <h2 class="mb-4">Coupon Management System</h2>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.message}
                        <button type="button" class="close" data-dismiss="alert">
                            <span>&times;</span>
                        </button>
                    </div>
                    <c:remove var="message" scope="session"/>
                </c:if>
                
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.error}
                        <button type="button" class="close" data-dismiss="alert">
                            <span>&times;</span>
                        </button>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>
                
                <!-- Action Buttons -->
                <div class="mb-3">
                    <a href="<%=request.getContextPath()%>/new" class="btn btn-success">
                        <i class="fas fa-plus"></i> Add New Coupon
                    </a>
                  </div>
                
                <!-- Coupons Table -->
                <div class="table-responsive">
                    <table class="table table-bordered table-striped">
                        <thead class="thead-dark">
                            <tr>
                                <th>ID</th>
                                <th>Code</th>
                                <th>Description</th>
                                <th>Discount</th>
                                <th>Type</th>
                                <th>Expiry Date</th>
                                <th>Usage</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="coupon" items="${listCoupons}">
                                <tr class="
                                   <c:choose>
    <c:when test="${!coupon.active}">inactive</c:when>
    <c:otherwise>valid</c:otherwise>
</c:choose>
                                ">
                                    <td>${coupon.id}</td>
                                    <td><strong>${coupon.code}</strong></td>
                                    <td>${coupon.description}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${coupon.discountType == 'PERCENTAGE'}">
                                                ${coupon.discountAmount}%
                                            </c:when>
                                            <c:otherwise>
                                                $<fmt:formatNumber value="${coupon.discountAmount}" type="number" minFractionDigits="2"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge badge-secondary">
                                            ${coupon.discountType}
                                        </span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${coupon.expiryDate}" pattern="MMM dd, yyyy"/>
                                    </td>
                                    <td>
                                        ${coupon.usedCount}
                                        <c:if test="${coupon.usageLimit > 0}">
                                            / ${coupon.usageLimit}
                                        </c:if>
                                        <c:if test="${coupon.usageLimit == 0}">
                                            / ∞
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
    <c:when test="${coupon.active}">
        <span class="badge badge-success status-badge">Active</span>
    </c:when>
    <c:otherwise>
        <span class="badge badge-secondary status-badge">Inactive</span>
    </c:otherwise>
</c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <a href="view?id=<c:out value='${coupon.id}' />" 
                                               class="btn btn-info btn-sm">View</a>
                                            <a href="edit?id=<c:out value='${coupon.id}' />" 
                                               class="btn btn-primary btn-sm">Edit</a>
                                            <a href="delete?id=<c:out value='${coupon.id}' />" 
                                               class="btn btn-danger btn-sm"
                                               onclick="return confirm('Are you sure you want to delete this coupon?')">Delete</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listCoupons}">
                                <tr>
                                    <td colspan="9" class="text-center">
                                        <p class="mb-0">No coupons found. <a href="<%=request.getContextPath()%>/new">Create your first coupon</a></p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                
                <!-- Legend -->
                <div class="mt-3">
                    <small class="text-muted">
                        <strong>Legend:</strong>
                        <span class="badge badge-success ml-2">Valid</span>
                        <span class="badge badge-danger ml-1">Expired</span>
                        <span class="badge badge-warning ml-1">Limit Reached</span>
                        <span class="badge badge-secondary ml-1">Inactive</span>
                    </small>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Coupon Details - ${coupon.code}</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .coupon-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .coupon-code {
            font-size: 2.5em;
            font-weight: bold;
            text-align: center;
            border: 3px dashed white;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            letter-spacing: 3px;
        }
        .detail-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 5px solid #007bff;
        }
        .status-valid { background-color: #d4edda; border-left-color: #28a745; }
        .status-expired { background-color: #f8d7da; border-left-color: #dc3545; }
        .status-inactive { background-color: #d1ecf1; border-left-color: #6c757d; }
        .status-limit { background-color: #fff3cd; border-left-color: #ffc107; }
        .progress-usage {
            height: 25px;
            border-radius: 15px;
        }
        .btn-action {
            margin: 5px;
            border-radius: 25px;
            padding: 10px 25px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <c:if test="${coupon != null}">
            <!-- Coupon Card -->
            <div class="coupon-card">
                <div class="row">
                    <div class="col-md-8">
                        <h1><i class="fas fa-ticket-alt"></i> Coupon Details</h1>
                        <div class="coupon-code">${coupon.code}</div>
                        <p class="lead">${coupon.description}</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${coupon.discountType == 'PERCENTAGE'}">
                                    <h2><i class="fas fa-percent"></i> ${coupon.discountAmount}%</h2>
                                    <small>Percentage Discount</small>
                                </c:when>
                                <c:otherwise>
                                    <h2><i class="fas fa-dollar-sign"></i><fmt:formatNumber value="${coupon.discountAmount}" type="number" minFractionDigits="2"/></h2>
                                    <small>Fixed Amount Discount</small>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Status Card -->
            <div class="detail-card 
                <c:choose>
                    <c:when test="${!coupon.active}">status-inactive</c:when>
                    <c:when test="${coupon.expired}">status-expired</c:when>
                    <c:when test="${coupon.usageLimitReached}">status-limit</c:when>
                    <c:otherwise>status-valid</c:otherwise>
                </c:choose>
            ">
                <h4><i class="fas fa-info-circle"></i> Status Information</h4>
                <div class="row">
                    <div class="col-md-3">
                        <strong>Current Status:</strong><br>
                        <c:choose>
                            <c:when test="${!coupon.active}">
                                <span class="badge badge-secondary badge-lg">Inactive</span>
                            </c:when>
                            <c:when test="${coupon.expired}">
                                <span class="badge badge-danger badge-lg">Expired</span>
                            </c:when>
                            <c:when test="${coupon.usageLimitReached}">
                                <span class="badge badge-warning badge-lg">Usage Limit Reached</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-success badge-lg">Valid & Active</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-3">
                        <strong>Expiry Date:</strong><br>
                        <fmt:formatDate value="${coupon.expiryDate}" pattern="MMM dd, yyyy"/>
                        <c:if test="${coupon.expired}">
                            <br><small class="text-danger">Expired</small>
                        </c:if>
                    </div>
                    <div class="col-md-3">
                        <strong>Created:</strong><br>
                        <fmt:formatDate value="${coupon.createdAt}" pattern="MMM dd, yyyy"/>
                    </div>
                    <div class="col-md-3">
                        <strong>Valid Until:</strong><br>
                        <c:choose>
                            <c:when test="${coupon.expired}">
                                <span class="text-danger">Already Expired</span>
                            </c:when>
                            <c:otherwise>
                                <jsp:useBean id="now" class="java.util.Date" />
                                <c:set var="daysLeft" value="${(coupon.expiryDate.time - now.time) / (1000 * 60 * 60 * 24)}" />
                                <fmt:parseNumber var="daysLeftInt" type="number" integerOnly="true" value="${daysLeft}" />
                                <c:choose>
                                    <c:when test="${daysLeftInt <= 0}">
                                        <span class="text-danger">Expires Today</span>
                                    </c:when>
                                    <c:when test="${daysLeftInt <= 7}">
                                        <span class="text-warning">${daysLeftInt} days left</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-success">${daysLeftInt} days left</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Usage Information -->
            <div class="detail-card">
                <h4><i class="fas fa-chart-bar"></i> Usage Information</h4>
                <div class="row">
                    <div class="col-md-6">
                        <strong>Times Used:</strong> ${coupon.usedCount}
                        <c:if test="${coupon.usageLimit > 0}">
                            / ${coupon.usageLimit}
                        </c:if>
                        <c:if test="${coupon.usageLimit == 0}">
                            / Unlimited
                        </c:if>
                        
                        <!-- Usage Progress Bar -->
                        <c:if test="${coupon.usageLimit > 0}">
                            <div class="mt-2">
                                <c:set var="usagePercent" value="${(coupon.usedCount * 100) / coupon.usageLimit}" />
                                <div class="progress progress-usage">
                                    <div class="progress-bar 
                                        <c:choose>
                                            <c:when test="${usagePercent >= 100}">bg-danger</c:when>
                                            <c:when test="${usagePercent >= 80}">bg-warning</c:when>
                                            <c:otherwise>bg-success</c:otherwise>
                                        </c:choose>
                                    " role="progressbar" style="width: ${usagePercent > 100 ? 100 : usagePercent}%" 
                                    aria-valuenow="${usagePercent}" aria-valuemin="0" aria-valuemax="100">
                                        <fmt:formatNumber value="${usagePercent}" type="number" maxFractionDigits="1"/>%
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                    <div class="col-md-6">
                        <strong>Usage Limit:</strong>
                        <c:choose>
                            <c:when test="${coupon.usageLimit == 0}">
                                <span class="text-success">Unlimited</span>
                            </c:when>
                            <c:otherwise>
                                ${coupon.usageLimit} times
                                <c:if test="${coupon.usageLimitReached}">
                                    <br><small class="text-danger">Limit reached!</small>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Validation Result -->
            <div class="detail-card">
                <h4><i class="fas fa-shield-alt"></i> Validation Check</h4>
                <c:choose>
                    <c:when test="${coupon.valid}">
                        <div class="alert alert-success" role="alert">
                            <i class="fas fa-check-circle"></i> <strong>This coupon is VALID and can be used!</strong>
                            <ul class="mb-0 mt-2">
                                <li>Coupon is active</li>
                                <li>Not expired</li>
                                <c:if test="${coupon.usageLimit > 0}">
                                    <li>Usage limit not reached (${coupon.usageLimit - coupon.usedCount} uses remaining)</li>
                                </c:if>
                                <c:if test="${coupon.usageLimit == 0}">
                                    <li>Unlimited usage available</li>
                                </c:if>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-times-circle"></i> <strong>This coupon is INVALID and cannot be used!</strong>
                            <ul class="mb-0 mt-2">
                                <c:if test="${!coupon.active}">
                                    <li>Coupon is inactive</li>
                                </c:if>
                                <c:if test="${coupon.expired}">
                                    <li>Coupon has expired</li>
                                </c:if>
                                <c:if test="${coupon.usageLimitReached}">
                                    <li>Usage limit has been reached</li>
                                </c:if>
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Action Buttons -->
            <div class="text-center">
                <a href="<%=request.getContextPath()%>/edit?id=${coupon.id}" 
                   class="btn btn-primary btn-action">
                    <i class="fas fa-edit"></i> Edit Coupon
                </a>
                <a href="<%=request.getContextPath()%>/list" 
                   class="btn btn-secondary btn-action">
                    <i class="fas fa-list"></i> Back to List
                </a>
                <a href="<%=request.getContextPath()%>/delete?id=${coupon.id}" 
                   class="btn btn-danger btn-action"
                   onclick="return confirm('Are you sure you want to delete this coupon?')">
                    <i class="fas fa-trash"></i> Delete Coupon
                </a>
            </div>
            
        </c:if>
        
        <c:if test="${coupon == null}">
            <div class="alert alert-warning text-center" role="alert">
                <i class="fas fa-exclamation-triangle"></i> Coupon not found!
                <br><br>
                <a href="<%=request.getContextPath()%>/list" class="btn btn-primary">
                    <i class="fas fa-list"></i> Back to Coupon List
                </a>
            </div>
        </c:if>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</body>
</html>
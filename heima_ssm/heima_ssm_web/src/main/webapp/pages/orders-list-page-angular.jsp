<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- 页面meta -->
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title>数据 - AdminLTE2定制版</title>
<meta name="description" content="AdminLTE2定制版">
<meta name="keywords" content="AdminLTE2定制版">

<!-- Tell the browser to be responsive to screen width -->
<meta
	content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no"
	name="viewport">

  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

<link rel="stylesheet"
	href="../plugins/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet"
	href="../plugins/font-awesome/css/font-awesome.min.css">
<link rel="stylesheet"
	href="../plugins/ionicons/css/ionicons.min.css">
<link rel="stylesheet"
	href="../plugins/iCheck/square/blue.css">
<link rel="stylesheet"
	href="../plugins/morris/morris.css">
<link rel="stylesheet"
	href="../plugins/jvectormap/jquery-jvectormap-1.2.2.css">
<link rel="stylesheet"
	href="../plugins/datepicker/datepicker3.css">
<link rel="stylesheet"
	href="../plugins/daterangepicker/daterangepicker.css">
<link rel="stylesheet"
	href="../plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">
<link rel="stylesheet"
	href="../plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet"
	href="../plugins/treeTable/jquery.treetable.css">
<link rel="stylesheet"
	href="../plugins/treeTable/jquery.treetable.theme.default.css">
<link rel="stylesheet"
	href="../plugins/select2/select2.css">
<link rel="stylesheet"
	href="../plugins/colorpicker/bootstrap-colorpicker.min.css">
<link rel="stylesheet"
	href="../plugins/bootstrap-markdown/css/bootstrap-markdown.min.css">
<link rel="stylesheet"
	href="../plugins/adminLTE/css/AdminLTE.css">
<link rel="stylesheet"
	href="../plugins/adminLTE/css/skins/_all-skins.min.css">
<link rel="stylesheet"
	href="../css/style.css">
<link rel="stylesheet"
	href="../plugins/ionslider/ion.rangeSlider.css">
<link rel="stylesheet"
	href="../plugins/ionslider/ion.rangeSlider.skinNice.css">
<link rel="stylesheet"
	href="../plugins/bootstrap-slider/slider.css">
<link rel="stylesheet"
	href="../plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.css">


	<script type="text/javascript" src="../plugins/angularjs/angular.min.js"></script>
	<!-- 分页组件开始 -->
	<script src="../plugins/angularjs/pagination.js"></script>
	<link rel="stylesheet" href="../plugins/angularjs/pagination.css">


</head>

<body class="hold-transition skin-purple sidebar-mini" ng-app="app" ng-controller="ordersController">

	<div class="wrapper">

		<!-- 页面头部 -->
		<jsp:include page="header.jsp"></jsp:include>
		<!-- 页面头部 /-->
		<!-- 导航侧栏 -->
		<jsp:include page="aside.jsp"></jsp:include>
		<!-- 导航侧栏 /-->

		<!-- 内容区域 -->
		<!-- @@master = admin-layout.html-->
		<!-- @@block = content -->

		<div class="content-wrapper">

			<!-- 内容头部 -->
			<section class="content-header">
				<h1>
					数据管理 <small>数据列表</small>
				</h1>
				<ol class="breadcrumb">
					<li><a href="#"><i class="fa fa-dashboard"></i> 首页</a></li>
					<li><a href="#">数据管理</a></li>
					<li class="active">数据列表</li>
				</ol>
			</section>
			<!-- 内容头部 /-->

			<!-- 正文区域 -->
			<section class="content">

				<!-- .box-body -->
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">列表</h3>
					</div>

					<div class="box-body">

						<!-- 数据表格 -->
						<div class="table-box">

							<!--工具栏-->
							<div class="pull-left">
								<div class="form-group form-inline">
									<div class="btn-group">
										<button type="button" class="btn btn-default" title="新建"
											onclick="location.href='../pages/product-add.jsp'">
											<i class="fa fa-file-o"></i> 新建
										</button>
										<button type="button" class="btn btn-default" title="删除">
											<i class="fa fa-trash-o"></i> 删除
										</button>
										<button type="button" class="btn btn-default" title="开启">
											<i class="fa fa-check"></i> 开启
										</button>
										<button type="button" class="btn btn-default" title="屏蔽">
											<i class="fa fa-ban"></i> 屏蔽
										</button>
										<button type="button" class="btn btn-default" title="刷新">
											<i class="fa fa-refresh"></i> 刷新
										</button>
									</div>
								</div>
							</div>
							<div class="box-tools pull-right">
								<div class="has-feedback">
									<input type="text" class="form-control input-sm"
										placeholder="搜索"> <span
										class="glyphicon glyphicon-search form-control-feedback"></span>
								</div>
							</div>
							<!--工具栏/-->

							<!--数据列表-->
							<table id="dataList"
								class="table table-bordered table-striped table-hover dataTable">
								<thead>
									<tr>
										<th class="" style="padding-right: 0px;"><input
											id="selall" type="checkbox" class="icheckbox_square-blue">
										</th>
										<th class="sorting_asc">ID</th>
										<th class="sorting_desc">订单编号</th>
										<th class="sorting_asc sorting_asc_disabled">产品名称</th>
										<th class="sorting_desc sorting_desc_disabled">金额</th>
										<th class="sorting">下单时间</th>
										<th class="text-center sorting">订单状态</th>
										<th class="text-center">操作</th>
									</tr>
								</thead>
								<tbody>
										<tr ng-repeat="entity in list">
											<td><input name="ids" type="checkbox"></td>
											<td>{{entity.id}}</td>
											<td>{{entity.orderNum}}</td>
											<td>{{entity.product.productName}}</td>
											<td>{{entity.product.productPrice}}</td>
											<td>{{entity.product.departureTime|date:'yyyy-MM-dd'}}</td>
											<td class="text-center">{{entity.orderStatus==1?'启用':'不可用'}}</td>
											<td class="text-center">
												<button type="button" class="btn bg-olive btn-xs">订单</button>
												<a class="btn bg-olive btn-xs" ng-href="../orders/findById.do?id={{entity.id}}">详情</a>
												<button type="button" class="btn bg-olive btn-xs">编辑</button>
											</td>
										</tr>
								</tbody>
							</table>
							<!--数据列表/-->



						</div>
						<!-- 数据表格 /-->


					</div>
					<!-- /.box-body -->

					<!-- .box-footer-->
                <div class="box-footer">
					<!--数据列表/-->
					<tm-pagination conf="paginationConf"></tm-pagination>
                </div>
                <!-- /.box-footer-->

				</div>

			</section>
			<!-- 正文区域 /-->

		</div>
		<!-- @@close -->
		<!-- 内容区域 /-->

		<!-- 底部导航 -->
		<footer class="main-footer">
			<div class="pull-right hidden-xs">
				<b>Version</b> 1.0.8
			</div>
			<strong>Copyright &copy; 2014-2017 <a
				href="http://www.itcast.cn">研究院研发部</a>.
			</strong> All rights reserved.
		</footer>
		<!-- 底部导航 /-->

	</div>


	<script
		src="../plugins/jQuery/jquery-2.2.3.min.js"></script>
	<script
		src="../plugins/jQueryUI/jquery-ui.min.js"></script>
	<script>
		$.widget.bridge('uibutton', $.ui.button);
	</script>
	<script
		src="../plugins/bootstrap/js/bootstrap.min.js"></script>
	<script
		src="../plugins/raphael/raphael-min.js"></script>
	<script
		src="../plugins/morris/morris.min.js"></script>
	<script
		src="../plugins/sparkline/jquery.sparkline.min.js"></script>
	<script
		src="../plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
	<script
		src="../plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
	<script
		src="../plugins/knob/jquery.knob.js"></script>
	<script
		src="../plugins/daterangepicker/moment.min.js"></script>
	<script
		src="../plugins/daterangepicker/daterangepicker.js"></script>
	<script
		src="../plugins/daterangepicker/daterangepicker.zh-CN.js"></script>
	<script
		src="../plugins/datepicker/bootstrap-datepicker.js"></script>
	<script
		src="../plugins/datepicker/locales/bootstrap-datepicker.zh-CN.js"></script>
	<script
		src="../plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
	<script
		src="../plugins/slimScroll/jquery.slimscroll.min.js"></script>
	<script
		src="../plugins/fastclick/fastclick.js"></script>
	<script
		src="../plugins/iCheck/icheck.min.js"></script>
	<script
		src="../plugins/adminLTE/js/app.min.js"></script>
	<script
		src="../plugins/treeTable/jquery.treetable.js"></script>
	<script
		src="../plugins/select2/select2.full.min.js"></script>
	<script
		src="../plugins/colorpicker/bootstrap-colorpicker.min.js"></script>
	<script
		src="../plugins/bootstrap-wysihtml5/bootstrap-wysihtml5.zh-CN.js"></script>
	<script
		src="../plugins/bootstrap-markdown/js/bootstrap-markdown.js"></script>
	<script
		src="../plugins/bootstrap-markdown/locale/bootstrap-markdown.zh.js"></script>
	<script
		src="../plugins/bootstrap-markdown/js/markdown.js"></script>
	<script
		src="../plugins/bootstrap-markdown/js/to-markdown.js"></script>
	<script
		src="../plugins/ckeditor/ckeditor.js"></script>
	<script
		src="../plugins/input-mask/jquery.inputmask.js"></script>
	<script
		src="../plugins/input-mask/jquery.inputmask.date.extensions.js"></script>
	<script
		src="../plugins/input-mask/jquery.inputmask.extensions.js"></script>
	<script
		src="../plugins/datatables/jquery.dataTables.min.js"></script>
	<script
		src="../plugins/datatables/dataTables.bootstrap.min.js"></script>
	<script
		src="../plugins/chartjs/Chart.min.js"></script>
	<script
		src="../plugins/flot/jquery.flot.min.js"></script>
	<script
		src="../plugins/flot/jquery.flot.resize.min.js"></script>
	<script
		src="../plugins/flot/jquery.flot.pie.min.js"></script>
	<script
		src="../plugins/flot/jquery.flot.categories.min.js"></script>
	<script
		src="../plugins/ionslider/ion.rangeSlider.min.js"></script>
	<script
		src="../plugins/bootstrap-slider/bootstrap-slider.js"></script>
	<script
		src="../plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>
	<script
		src="../plugins/bootstrap-datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
	<script>
		function changePageSize() {
			//获取下拉框的值
			var pageSize = $("#changePageSize").val();

			//向服务器发送请求，改变没页显示条数
			location.href = "../orders/findAll.do?page=1&pageSize="
					+ pageSize;
		}
		$(document).ready(function() {
			// 选择框
			$(".select2").select2();

			// WYSIHTML5编辑器
			$(".textarea").wysihtml5({
				locale : 'zh-CN'
			});
		});

		// 设置激活菜单
		function setSidebarActive(tagUri) {
			var liObj = $("#" + tagUri);
			if (liObj.length > 0) {
				liObj.parent().parent().addClass("active");
				liObj.addClass("active");
			}
		}

		$(document).ready(function() {

			// 激活导航位置
			setSidebarActive("admin-datalist");

			// 列表按钮 
			$("#dataList td input[type='checkbox']").iCheck({
				checkboxClass : 'icheckbox_square-blue',
				increaseArea : '20%'
			});
			// 全选操作 
			$("#selall").click(function() {
				var clicks = $(this).is(':checked');
				if (!clicks) {
					$("#dataList td input[type='checkbox']").iCheck("uncheck");
				} else {
					$("#dataList td input[type='checkbox']").iCheck("check");
				}
				$(this).data("clicks", !clicks);
			});
		});




        var app=angular.module('app',['pagination']);
        app.controller('ordersController',function($scope,$http){
            //分页控件配置
			// currentPage:当前页
			// itemsPerPage:每页记录数
			// perPageOptions :分页选项
			// onChange:当页码变更后自动触发的方法
            $scope.paginationConf = {
                currentPage: 1,
                itemsPerPage: 5,
                perPageOptions: [1, 3, 5, 10, 15],
                onChange: function(){
                    $scope.findPage($scope.paginationConf.currentPage , $scope.paginationConf.itemsPerPage);
                }
            };
            //分页
            $scope.findPage=function(page,size){
                $http.get('../orders/findAll.do?page='+page +'&size='+size).success(
                    function(response){
                        $scope.list=response.list;//显示当前页数据
                        $scope.paginationConf.totalItems=response.total;//更新总记录数
                    }
                );
            }
        });












	</script>
</body>

</html>
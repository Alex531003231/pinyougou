app.controller('searchController',function($scope,$location,searchService){


	//定义搜索对象的结构
	$scope.searchMap={'keywords':'','category':'','brand':'','spec':{},'price':'','pageNo':1,'pageSize':40,'sortFiled':'','sort':''};


	//搜索
	$scope.search=function(){
		$scope.searchMap.pageNo=parseInt($scope.searchMap.pageNo);

		searchService.search($scope.searchMap).success(
			function(response){
				$scope.resultMap=response;//搜索返回的结果
                buildPageLabel();//调用分页标签方法
			}
		);		
	}

	//添加搜索项
	$scope.addSearchItem=function (key, value) {
		if(key=='category' || key=='brand' || key=='price'){
			$scope.searchMap[key]=value;
		}else{
			$scope.searchMap.spec[key]=value;
		}
        $scope.search();//查询
    }

    //移除搜索选项
	$scope.removeSearchItem=function (key) {
        if(key=='category' || key=='brand' || key=='price'){
            $scope.searchMap[key]="";
        }else{
            delete $scope.searchMap.spec[key];
        }
        $scope.search();//查询
    }

    //构建分页标签(totalPages为总页数)
	buildPageLabel=function () {
		$scope.pageLabel=[];
		var maxPageNo=$scope.resultMap.totalPages;//得到最后页码
		var firstPage=1;//开始页码
		var lastPage=maxPageNo;//截止页码

		$scope.firstDot=true;//前面有点
        $scope.lastDot=true;//后面有点




		if ($scope.resultMap.totalPages>5){//如果总页数大于5页，显示部分页码
			if ($scope.searchMap.pageNo<=3){//如果当前页小于等于3
				lastPage=5;
				$scope.firstDot=false;//前面没点
			}else if($scope.searchMap.pageNo>=lastPage-2){//如果当前页大于等于最大值页码-2
				firstPage=maxPageNo-4;//后5页
				$scope.lastDot=false;//后面没点
			}else{
				firstPage=$scope.searchMap.pageNo-2;
				lastPage=$scope.searchMap.pageNo+2;
			}
		}else {
            $scope.firstDot=false;//前面无点
            $scope.lastDot=false;//后面无点
        }

		//循环产生页码标签
		for(var i=firstPage;i<=lastPage;i++){
			$scope.pageLabel.push(i);
		}
    }

    //根据页码查询
	$scope.queryByPage=function (pageNo) {
		//页码验证
		if(pageNo<1 || pageNo>$scope.resultMap.totalPages){
			return;
		}
		$scope.searchMap.pageNo=pageNo;
		$scope.search();
    }

    //判断当前页为第一页
	$scope.isTopPage=function () {
		if ($scope.searchMap.pageNo==1){
			return true;
		}else{
			return false;
		}
    }
    //判断当前页是否为最后一页
	$scope.isEndPage=function () {
		if($scope.searchMap.pageNo==$scope.resultMap.totalPages){
			return true;
		}else {
			return false;
		}
    }

    //设置排序规则
	$scope.sortSearch=function (sortFiled, sort) {
		$scope.searchMap.sortFiled=sortFiled;
		$scope.searchMap.sort=sort;
		$scope.search();
    }

    //判断关键字是不是品牌
    $scope.keywordsIsBrand=function () {
        for(var i=0;i<$scope.resultMap.brandList.length;i++){
            if($scope.searchMap.keywords.indexOf($scope.resultMap.brandList[i].text)>=0){//如果包含
                return true;
            }
        }
        return false;
    }

	//加载查询字符串
    $scope.loadkeywords=function () {
        $scope.searchMap.keywords=$location.search()['keywords'];
        $scope.search();
    }

});
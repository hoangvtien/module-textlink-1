<!-- BEGIN: main -->
<link type="text/css" href="{NV_BASE_SITEURL}{NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.css" rel="stylesheet" />

<!-- BEGIN: error -->
<div class="alert alert-warning">{ERROR}</div>
<!-- END: error -->
<div class="panel panel-default">
<div class="panel-body">
<form class="form-horizontal" action="{NV_BASE_ADMINURL}index.php?{NV_LANG_VARIABLE}={NV_LANG_DATA}&amp;{NV_NAME_VARIABLE}={MODULE_NAME}&amp;{NV_OP_VARIABLE}={OP}" method="post">
	<input type="hidden" name="id" value="{ROW.id}" />
	<div class="form-group">
		<label class="col-sm-5 col-md-4 control-label"><strong>{LANG.customer_id}</strong> <span class="red">(*)</span></label>
		<div class="col-sm-19 col-md-20">
			<select class="form-control" name="customer_id">
				<option value=""> --- </option>
				<!-- BEGIN: select_customer_id -->
				<option value="{OPTION.key}" {OPTION.selected}>{OPTION.title}</option>
				<!-- END: select_customer_id -->
			</select>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-5 col-md-4 control-label"><strong>{LANG.a_title}</strong> <span class="red">(*)</span></label>
		<div class="col-sm-19 col-md-20">
			<input class="form-control" type="text" name="a_title" value="{ROW.a_title}" required="required" oninvalid="setCustomValidity( nv_required )" oninput="setCustomValidity('')" />
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-5 col-md-4 control-label"><strong>{LANG.attr_title_use}</strong></label>
		<div class="col-sm-19 col-md-20">
			<div class="row">
				<div class="col-xs-12 col-sm-6">
					<select class="form-control" name="attr_title_use">
						<!-- BEGIN: attr_title_use -->
						<option value="{OPTION.index}" {OPTION.selected}>{OPTION.value}</option>
						<!-- END: attr_title_use -->
					</select>
				</div>
				<div class="col-xs-12 col-sm-18">
					<input class="form-control" type="text" name="attr_title_content" value="{ROW.attr_title_content}" id="attr_title_content" placeholder="{LANG.attr_title_content}" <!-- BEGIN: disabled -->disabled<!-- END: disabled --> />
				</div>
			</div>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-5 col-md-4 control-label"><strong>{LANG.a_url}</strong> <span class="red">(*)</span></label>
		<div class="col-sm-19 col-md-20">
			<input class="form-control" type="url" name="a_url" value="{ROW.a_url}" oninvalid="setCustomValidity( nv_url )" oninput="setCustomValidity('')" required="required" />
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-5 col-md-4 control-label"><strong>{LANG.begin_time}</strong> <span class="red">(*)</span></label>
		<div class="col-sm-19 col-md-20">
			<div class="input-group">
			<input class="form-control" type="text" name="begin_time" value="{ROW.begin_time}" id="begin_time" pattern="^[0-9]{2,2}\/[0-9]{2,2}\/[0-9]{1,4}$" required="required" oninvalid="setCustomValidity( nv_required )" oninput="setCustomValidity('')" />
				<span class="input-group-btn">
					<button class="btn btn-default" type="button" id="begin_time-btn">
						<em class="fa fa-calendar fa-fix"> </em>
					</button> </span>
				</div>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-5 col-md-4 control-label"><strong>{LANG.end_time}</strong></label>
		<div class="col-sm-19 col-md-20">
			<div class="row">
				<div class="col-xs-4">
					<select class="form-control" id="month">
						<option value=""></option>
						<!-- BEGIN: month -->
						<option value="{MONTH}">{MONTH} {LANG.month}</option>
						<!-- END: month -->
					</select>
				</div>
				<div class="col-xs-20">
					<div class="input-group">
					<input class="form-control" type="text" name="end_time" value="{ROW.end_time}" id="end_time" pattern="^[0-9]{2,2}\/[0-9]{2,2}\/[0-9]{1,4}$" />
						<span class="input-group-btn">
							<button class="btn btn-default" type="button" id="end_time-btn">
								<em class="fa fa-calendar fa-fix"> </em>
							</button> </span>
						</div>
				</div>
			</div>
		</div>
	</div>
	<div class="form-group" style="text-align: center"><input class="btn btn-primary" name="submit" type="submit" value="{LANG.save}" /></div>
</form>
</div></div>

<script type="text/javascript" src="{NV_BASE_SITEURL}{NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="{NV_BASE_SITEURL}{NV_ASSETS_DIR}/js/language/jquery.ui.datepicker-{NV_LANG_INTERFACE}.js"></script>
<script type="text/javascript">
//<![CDATA[
	$("#begin_time,#end_time").datepicker({
		dateFormat : "dd/mm/yy",
		changeMonth : true,
		changeYear : true,
		showOtherMonths : true,
	});
	
	$('select[name="attr_title_use"]').change(function(){
		if($(this).val() == 0){
			$('#attr_title_content').prop('disabled', true);
		}else{
			$('#attr_title_content').prop('disabled', false);
		}
	});

	$('#month').change(function(){
		var begin_time = $('#begin_time').val();
		var month = $('#month').val();
		$.post(script_name + '?' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=content&nocache=' + new Date().getTime(), 'get_time_end=1&begin_time=' + begin_time + '&month=' + month, function(res) {
			var r_split = res.split('_');
			if (r_split[0] == 'OK') {
				$('#end_time').val(r_split[1]);
			}
		});
	});
//]]>
</script>
<!-- END: main -->
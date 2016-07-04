<!-- BEGIN: main -->
<!-- BEGIN: view -->
<div class="well">
<form action="{NV_BASE_ADMINURL}index.php" method="get">
	<input type="hidden" name="{NV_LANG_VARIABLE}"  value="{NV_LANG_DATA}" />
	<input type="hidden" name="{NV_NAME_VARIABLE}"  value="{MODULE_NAME}" />
	<input type="hidden" name="{NV_OP_VARIABLE}"  value="{OP}" />
	<div class="row">
		<div class="col-xs-24 col-md-6">
			<div class="form-group">
				<input class="form-control" type="text" value="{Q}" name="q" maxlength="255" placeholder="{LANG.search_title}" />
			</div>
		</div>
		<div class="col-xs-12 col-md-3">
			<div class="form-group">
				<input class="btn btn-primary" type="submit" value="{LANG.search_submit}" />
			</div>
		</div>
	</div>
</form>
</div>
<form action="{NV_BASE_ADMINURL}index.php?{NV_LANG_VARIABLE}={NV_LANG_DATA}&amp;{NV_NAME_VARIABLE}={MODULE_NAME}&amp;{NV_OP_VARIABLE}={OP}" method="post">
	<div class="table-responsive">
		<table class="table table-striped table-bordered table-hover">
			<colgroup>
				<col class="w50" />
				<col />
				<col class="w250" />
				<col class="w150" span="2" />
			</colgroup>
			<thead>
				<tr>
					<th class="text-center">{LANG.number}</th>
					<th>{LANG.name}</th>
					<th>{LANG.email}</th>
					<th>{LANG.phone}</th>
					<th class="w150">&nbsp;</th>
				</tr>
			</thead>
			<!-- BEGIN: generate_page -->
			<tfoot>
				<tr>
					<td class="text-center" colspan="5">{NV_GENERATE_PAGE}</td>
				</tr>
			</tfoot>
			<!-- END: generate_page -->
			<tbody>
				<!-- BEGIN: loop -->
				<tr>
					<td class="text-center"> {VIEW.number} </td>
					<td> {VIEW.name} </td>
					<td> {VIEW.email} </td>
					<td> {VIEW.phone} </td>
					<td class="text-center"><i class="fa fa-edit fa-lg">&nbsp;</i> <a href="{VIEW.link_edit}#edit">{LANG.edit}</a> - <em class="fa fa-trash-o fa-lg">&nbsp;</em> <a href="{VIEW.link_delete}" onclick="return confirm(nv_is_del_confirm[0]);">{LANG.delete}</a></td>
				</tr>
				<!-- END: loop -->
			</tbody>
		</table>
	</div>
</form>
<!-- END: view -->

<!-- BEGIN: error -->
<div class="alert alert-warning">{ERROR}</div>
<!-- END: error -->
<div class="panel panel-default">
<div class="panel-body">
<form class="form-horizontal" action="{NV_BASE_ADMINURL}index.php?{NV_LANG_VARIABLE}={NV_LANG_DATA}&amp;{NV_NAME_VARIABLE}={MODULE_NAME}&amp;{NV_OP_VARIABLE}={OP}" method="post">
	<input type="hidden" name="id" value="{ROW.id}" />
	<div class="form-group">
		<label class="col-sm-5 col-md-4 control-label"><strong>{LANG.name}</strong> <span class="red">(*)</span></label>
		<div class="col-sm-19 col-md-20">
			<input class="form-control" type="text" name="name" value="{ROW.name}" required="required" oninvalid="setCustomValidity( nv_required )" oninput="setCustomValidity('')" />
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-5 col-md-4 control-label"><strong>{LANG.email}</strong> <span class="red">(*)</span></label>
		<div class="col-sm-19 col-md-20">
			<input class="form-control" type="email" name="email" value="{ROW.email}" oninvalid="setCustomValidity( nv_email )" oninput="setCustomValidity('')" required="required" />
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-5 col-md-4 control-label"><strong>{LANG.phone}</strong></label>
		<div class="col-sm-19 col-md-20">
			<input class="form-control" type="text" name="phone" value="{ROW.phone}" />
		</div>
	</div>
	<div class="form-group" style="text-align: center"><input class="btn btn-primary" name="submit" type="submit" value="{LANG.save}" /></div>
</form>
</div></div>

<script type="text/javascript">
//<![CDATA[
	function nv_change_status(id) {
		var new_status = $('#change_status_' + id).is(':checked') ? true : false;
		if (confirm(nv_is_change_act_confirm[0])) {
			var nv_timer = nv_settimeout_disable('change_status_' + id, 5000);
			$.post(script_name + '?' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=customer&nocache=' + new Date().getTime(), 'change_status=1&id='+id, function(res) {
				var r_split = res.split('_');
				if (r_split[0] != 'OK') {
					alert(nv_is_change_act_confirm[2]);
				}
			});
		}
		else{
			$('#change_status_' + id).prop('checked', new_status ? false : true );
		}
		return;
	}
//]]>
</script>
<!-- END: main -->
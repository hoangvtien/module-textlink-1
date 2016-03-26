<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC (contact@vinades.vn)
 * @Copyright (C) 2016 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate Sat, 26 Mar 2016 00:20:04 GMT
 */

if ( ! defined( 'NV_IS_FILE_ADMIN' ) ) die( 'Stop!!!' );

$row = array();
$error = array();
$row['id'] = $nv_Request->get_int( 'id', 'post,get', 0 );

if( $row['id'] > 0 )
{
	$row = $db->query( 'SELECT * FROM ' . NV_PREFIXLANG . '_' . $module_data . ' WHERE id=' . $row['id'] )->fetch();
	if( empty( $row ) )
	{
		Header( 'Location: ' . NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name );
		die();
	}
	$lang_module['content'] = $lang_module['edittextlink'];
}
else
{
	$lang_module['content'] = $lang_module['addtextlink'];

	$row['id'] = 0;
	$row['a_title'] = '';
	$row['a_url'] = '';
	$row['customer_id'] = 0;
	$row['begin_time'] = NV_CURRENTTIME;
	$row['end_time'] = 0;
}

if ( $nv_Request->isset_request( 'submit', 'post' ) )
{
	$row['a_title'] = $nv_Request->get_title( 'a_title', 'post', '' );
	$row['a_url'] = $nv_Request->get_title( 'a_url', 'post', '' );
	$row['customer_id'] = $nv_Request->get_int( 'customer_id', 'post', 0 );
	if( preg_match( '/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $nv_Request->get_string( 'begin_time', 'post' ), $m ) )
	{
		$_hour = 0;
		$_min = 0;
		$row['begin_time'] = mktime( $_hour, $_min, 0, $m[2], $m[1], $m[3] );
	}
	else
	{
		$row['begin_time'] = 0;
	}
	if( preg_match( '/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $nv_Request->get_string( 'end_time', 'post' ), $m ) )
	{
		$row['end_time'] = mktime( 23, 59, 59, $m[2], $m[1], $m[3] );
	}
	else
	{
		$row['end_time'] = 0;
	}

	if( empty( $row['a_title'] ) )
	{
		$error[] = $lang_module['error_required_a_title'];
	}
	elseif( empty( $row['a_url'] ) )
	{
		$error[] = $lang_module['error_required_a_url'];
	}
	elseif( empty( $row['customer_id'] ) )
	{
		$error[] = $lang_module['error_required_customer_id'];
	}
	elseif( empty( $row['begin_time'] ) )
	{
		$error[] = $lang_module['error_required_begin_time'];
	}
	elseif( ! empty( $row['end_time'] ) and $row['end_time'] < $row['begin_time'] )
	{
		$error[] = $lang_module['error_end_time'];
	}
	elseif( ! empty( $row['a_url'] ) and ! nv_is_url( $row['a_url'] ) )
	{
		$error[] = $lang_module['error_url_a_url'];
	}

	if( empty( $error ) )
	{
		try
		{
			if( empty( $row['id'] ) )
			{
				$stmt = $db->prepare( 'INSERT INTO ' . NV_PREFIXLANG . '_' . $module_data . ' (a_title, a_url, customer_id, begin_time, end_time, weight) VALUES (:a_title, :a_url, :customer_id, :begin_time, :end_time, :weight)' );

				$weight = $db->query( 'SELECT max(weight) FROM ' . NV_PREFIXLANG . '_' . $module_data . '' )->fetchColumn();
				$weight = intval( $weight ) + 1;
				$stmt->bindParam( ':weight', $weight, PDO::PARAM_INT );
			}
			else
			{
				$stmt = $db->prepare( 'UPDATE ' . NV_PREFIXLANG . '_' . $module_data . ' SET a_title = :a_title, a_url = :a_url, customer_id = :customer_id, begin_time = :begin_time, end_time = :end_time WHERE id=' . $row['id'] );
			}
			$stmt->bindParam( ':a_title', $row['a_title'], PDO::PARAM_STR );
			$stmt->bindParam( ':a_url', $row['a_url'], PDO::PARAM_STR );
			$stmt->bindParam( ':customer_id', $row['customer_id'], PDO::PARAM_INT );
			$stmt->bindParam( ':begin_time', $row['begin_time'], PDO::PARAM_INT );
			$stmt->bindParam( ':end_time', $row['end_time'], PDO::PARAM_INT );

			$exc = $stmt->execute();
			if( $exc )
			{
				$nv_Cache->delMod( $module_name );
				Header( 'Location: ' . NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name );
				die();
			}
		}
		catch( PDOException $e )
		{
			trigger_error( $e->getMessage() );
			die( $e->getMessage() ); //Remove this line after checks finished
		}
	}
}

if( empty( $row['begin_time'] ) )
{
	$row['begin_time'] = '';
}
else
{
	$row['begin_time'] = date( 'd/m/Y', $row['begin_time'] );
}

if( empty( $row['end_time'] ) )
{
	$row['end_time'] = '';
}
else
{
	$row['end_time'] = date( 'd/m/Y', $row['end_time'] );
}

$array_customer_id_textlink = array();
$_sql = 'SELECT id, name FROM ' . NV_PREFIXLANG . '_' . $module_data . '_customer';
$_query = $db->query( $_sql );
while( $_row = $_query->fetch() )
{
	$array_customer_id_textlink[$_row['id']] = $_row;
}

$xtpl = new XTemplate( $op . '.tpl', NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file );
$xtpl->assign( 'LANG', $lang_module );
$xtpl->assign( 'MODULE_NAME', $module_name );
$xtpl->assign( 'MODULE_UPLOAD', $module_upload );
$xtpl->assign( 'OP', $op );
$xtpl->assign( 'ROW', $row );

foreach( $array_customer_id_textlink as $value )
{
	$xtpl->assign( 'OPTION', array(
		'key' => $value['id'],
		'title' => $value['name'],
		'selected' => ($value['id'] == $row['customer_id']) ? ' selected="selected"' : ''
	) );
	$xtpl->parse( 'main.select_customer_id' );
}

if( ! empty( $error ) )
{
	$xtpl->assign( 'ERROR', implode( '<br />', $error ) );
	$xtpl->parse( 'main.error' );
}

$xtpl->parse( 'main' );
$contents = $xtpl->text( 'main' );

$page_title = $lang_module['content'];

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme( $contents );
include NV_ROOTDIR . '/includes/footer.php';
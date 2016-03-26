<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC (contact@vinades.vn)
 * @Copyright (C) 2014 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate Sat, 10 Dec 2011 06:46:54 GMT
 */

if (! defined('NV_MAINFILE')) {
    die('Stop!!!');
}

if (! nv_function_exists('nv_block_textlink')) {
    function nv_block_textlink($block_config)
    {
        global $nv_Cache, $module_array_cat, $module_info, $site_mods, $module_config, $global_config, $db;

        $module = $block_config['module'];

        $db->sqlreset()
            ->select('*')
            ->from(NV_PREFIXLANG . '_' . $site_mods[$module]['module_data'])
            ->where('status=1 AND begin_time <= ' . NV_CURRENTTIME . ' AND (end_time >= ' . NV_CURRENTTIME . ' OR end_time=0)' )
            ->order('weight');

        $result = $db->query($db->sql());

        if ($num = $result->rowCount() > 0) {
            if (file_exists(NV_ROOTDIR . '/themes/' . $global_config['module_theme']  . '/modules/' . $site_mods[$module]['module_file'] . '/block_textlink.tpl')) {
                $block_theme = $global_config['module_theme'] ;
            } else {
                $block_theme = 'default';
            }

            $xtpl = new XTemplate('block_textlink.tpl', NV_ROOTDIR . '/themes/' . $block_theme . '/modules/' . $site_mods[$module]['module_file']);
            $xtpl->assign('TEMPLATE', $block_theme);

			$i=0;
            while ($row = $result->fetch()) {
            	$xtpl->assign('ROW', $row);
				if($i<$num){
					$xtpl->parse('main.loop.space');
				}
                $xtpl->parse('main.loop');
				$i++;
            }

            $xtpl->parse('main');
            return $xtpl->text('main');
        }
    }
}
if (defined('NV_SYSTEM')) {
    global $site_mods, $module_name;

    $module = $block_config['module'];
    if (isset($site_mods[$module])) {
        $content = nv_block_textlink($block_config);
    }
}

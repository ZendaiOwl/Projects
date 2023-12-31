<?php
declare(strict_types=1);
// SPDX-FileCopyrightText: Victor-ray, S. <zendaiowl@skiff.com>
// SPDX-License-Identifier: AGPL-3.0-or-later

namespace OCA\Translate\AppInfo;

use OCP\AppFramework\App;

class Application extends App {
	public const APP_ID = 'translate';

	public function __construct() {
		parent::__construct(self::APP_ID);
	}
}

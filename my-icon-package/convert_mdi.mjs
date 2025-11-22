import { promises as fs } from 'fs';
import { validateIconSet } from '@iconify/utils';

(async () => {
	// ① 只要把这里换成你的 json 路径就行
	const data = JSON.parse(
		await fs.readFile('./icons.json', 'utf8')   // ← 改这里
	);

	const iconSet = validateIconSet(data);     // ② 自动校验
	const count =
		Object.keys(iconSet.icons).length +
		(iconSet.aliases ? Object.keys(iconSet.aliases).length : 0);
	console.log(`图标数：${count}`);
	console.log('前缀：', iconSet.prefix);
	console.log('样本：', Object.keys(iconSet.icons).slice(0, 5));
})();
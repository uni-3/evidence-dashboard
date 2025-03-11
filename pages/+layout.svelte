<script>
	import '@evidence-dev/tailwind/fonts.css';
	import '../app.css';
	import { EvidenceDefaultLayout } from '@evidence-dev/core-components';
	export let data;
</script>

<EvidenceDefaultLayout
   data={data}
   logo="/icon-192.png"
   githubRepo="https://github.com/uni-3/evidence-dashboard"
   neverShowQueries=true
 >
	<slot slot="content" />
</EvidenceDefaultLayout>

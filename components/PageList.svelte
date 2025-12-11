<script>
  export let folder = './';

  const modules = import.meta.glob('../pages/**/*.md', {
    query: '?raw',
    import: 'default',
    eager: true
  });

  const pages = Object.entries(modules).map(([filepath, content]) => {
    // xxx/index.md -> xxx
    // xxx/test.md -> xxx/test
    let linkPath = filepath
      .replace('../pages', '')
      .replace('/index.md', '')
      .replace('.md', '');
    if (linkPath === '') linkPath = '/';

    const titleMatch = content.match(/^title:\s*(.*)$/m);
    const title = titleMatch
      ? titleMatch[1].trim().replace(/^["']|["']$/g, '')
      : linkPath;
    // sidebar_link: false で非表示
    const isHidden = content.match(/^sidebar_link:\s*false/m);

    return {
      title,
      path: linkPath,
      //hidden: !!isHidden,
    };
  });

  $: filteredPages = pages.filter(p => {
    const searchFolder = folder === './' ? '' : folder.replace(/\/$/, '');
    return (
      // exclude own page
      p.path !== searchFolder &&
      // only include sub pages
      p.path.startsWith(searchFolder) &&
      // exclude hidden pages
      // !p.hidden &&
      // パスに '[' が含まれる（=動的ルート）除外
      !p.path.includes('[')
    );
  });
</script>

<div class="not-prose grid gap-4 grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 my-6">
  {#each filteredPages as page}
    <a href={page.path}
       class="block p-6 border rounded-lg hover:shadow-md hover:border-blue-500 transition-all no-underline bg-white group">

      <h3 class="text-lg font-semibold text-gray-900 group-hover:text-blue-600 mb-2">
        {page.title}
      </h3>

      <p class="text-sm text-gray-400 font-mono">
        {page.path}
      </p>
    </a>
  {/each}
</div>

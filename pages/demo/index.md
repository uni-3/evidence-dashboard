---
title: demo page
sidebar_link: false
sidebar: never
---

welcome demo page

<script>
  // vitaの機能。ファイルパス一覧を取得
  const modules = import.meta.glob('./**/+page.md');

  const pages = Object.entries(modules).map(([path, mod]) => {
    // パスからファイル名などを整形
    // see .ebidence/template/src/pages
    const slug = path.replace('./', '').replace('/+page.md', '');

    return {
      title: slug,
      path: './' + slug
    };
  }).filter(Boolean); // null (自分自身) をリストから消す
</script>

## デモ一覧

<ul class="list-disc pl-6 space-y-2 my-4">
  {#each pages as page}
    <li>
      <a href={page.path} class="text-blue-600 hover:text-blue-800 hover:underline transition-colors font-medium">
        {page.title}
      </a>
    </li>
  {/each}
</ul>

<!-- <PageList folder="/demo" /> -->

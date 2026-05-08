# Project: dotfiles

個人用 dotfiles リポジトリ。zsh / Neovim / Vim / tmux / git 等の設定を管理する。

## 健全性チェック (`bin/dotfiles-doctor`)

`scripts/doctor/` のチェック群と `.github/workflows/doctor.yml` で月次健全性レポートを Issue として upsert する仕組み。詳細は README の "🩺 dotfiles-doctor" 節を参照。

### AI Review のサブIssue化ルール

`Dotfiles Health Report` Issue (`dotfiles-health` ラベル) の **AI Review** セクションに含まれる指摘は、個別に取り組めるよう **GitHub Sub-issues 機能で親Issueにぶら下げる** 形でサブIssue化する。

**フロー:**
1. AI Review 内の各箇条書きを評価し、対応する価値がある項目だけを抽出する（severity が `high` / `medium` を優先、`low` でも対応コストが小さければ採用）
2. 同種の項目はまとめて1サブIssueにする（例: 複数の同じカテゴリのプラグイン整理）
3. 各サブIssueに対応する親Issue (`Dotfiles Health Report`) を Sub-issue API で紐付ける
4. severity に対応するラベルを付与（`priority:high` / `priority:medium` / `priority:low`）

**コマンド例:**

```bash
# 親Issue番号
PARENT=13
PARENT_REPO=winky/dotfiles

# 1) 子Issue を通常通り作成
CHILD_NUM=$(gh issue create --repo "$PARENT_REPO" \
  --title "..." --body "..." --label "priority:medium" \
  --json number --jq .number)

# 2) 子Issue の REST id を取得（Sub-issue API は数値idを要求）
CHILD_ID=$(gh api "repos/$PARENT_REPO/issues/$CHILD_NUM" --jq .id)

# 3) 親に紐付け
gh api --method POST "repos/$PARENT_REPO/issues/$PARENT/sub_issues" \
  -F sub_issue_id="$CHILD_ID"
```

**サブIssue body の体裁:**
- 冒頭に `Spawned from #<parent>` を記載（API紐付けと併用、可視性のため）
- AI Review の原文を引用
- 推奨される対応手順または検証ポイントを箇条書きで添える

**Issue化しない項目:**
- 単なる情報共有（severity `low` かつ対応不要）
- すでに別Issueがある内容
- 1〜2分で本人が判断・対処できる些末事

**ラウンドのクローズ:**
- 紐付いたサブIssueがすべて closed になったら、親 (`Dotfiles Health Report`) も対応サマリを残してクローズする
- 次回CI実行時、`--state open` のトラッキングIssueが見つからなければ workflow が新しい親Issueを自動作成する（`.github/workflows/doctor.yml`の挙動）
- これにより1ラウンド = 1親Issue という形で履歴が保てる

## Conventions

- Conventional Commits (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`)
- コミットメッセージは英語、PR 本文は日本語可
- `git merge` (no rebase) when integrating master

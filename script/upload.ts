import { getOctokit } from "npm:@actions/github";
import { Command } from "jsr:@cliffy/command@1.0.0-rc.4";
import { join, parse } from "jsr:@std/path";
import { walk } from "jsr:@std/fs";
// import { ZipWriter } from "jsr:@zip-js/zip-js";

for await (const e of walk("", {})) {
  e;
}

const isDirectory = async (path: string): Promise<boolean> => {
  const fileName = parse(path).base;
  for await (const file of Deno.readDir(join(path, ".."))) {
    if (file.name === fileName) {
      return file.isDirectory;
    }
  }
  throw new Error(`File or Directory not found: ${path}`);
};

const getFileContentOrZippedDir = async (path: string): Promise<Uint8Array> => {
  const isDir = await isDirectory(path);
  if (isDir) {
    for await (const entry of walk(path)) {
      console.log(entry.path);
    }
    return new Uint8Array();
  }
  return await Deno.readFile(path);
};

await new Command()
  .env(
    "GITHUB_TOKEN=<value>",
    "",
    { required: true },
  ).env(
    "GITHUB_REPOSITORY_OWNER=<value>",
    "",
    { required: true },
  ).env("GITHUB_REPOSITORY_NAME=<value>", "", { required: true }).option(
    "--releaseId=<value:integer>",
    "database id of the release.",
    { required: true },
  ).option(
    "--name=<value>",
    "",
    { required: true },
  ).option(
    "--path=<value>",
    "",
    { required: true },
  )
  .action(
    async (
      {
        githubToken,
        githubRepositoryOwner,
        githubRepositoryName,
        releaseId,
        name,
        path,
      },
    ) => {
      const octokit = getOctokit(githubToken);

      const assets = await octokit.rest.repos.listReleaseAssets({
        owner: githubRepositoryOwner,
        repo: githubRepositoryName,
        release_id: releaseId,
      });
      const asset = assets.data.find((asset) => asset.name === name);
      if (asset !== undefined) {
        await octokit.rest.repos.deleteReleaseAsset({
          asset_id: asset.id,
          owner: githubRepositoryOwner,
          repo: githubRepositoryName,
        });
      }
      await octokit.rest.repos.uploadReleaseAsset({
        owner: githubRepositoryOwner,
        repo: githubRepositoryName,
        release_id: releaseId,
        name,
        data: await getFileContentOrZippedDir(path) as unknown as string,
      });
    },
  ).parse();
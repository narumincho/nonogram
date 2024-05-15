import { Command } from "jsr:@cliffy/command@1.0.0-rc.4";
import { fromFileUrl, join, parse } from "jsr:@std/path";
// import { walk } from "jsr:@std/fs";
import {
  Uint8ArrayReader,
  Uint8ArrayWriter,
  ZipWriter,
} from "jsr:@zip-js/zip-js";
import ky from "https://esm.sh/ky@1.2.4";

/**
 * https://docs.github.com/ja/rest/releases/assets?apiVersion=2022-11-28#list-release-assets
 *
 * `@octokit/core` を使うと
 * ```txt
 * Uncaught (in promise) HttpError: Not Found - https://docs.github.com/rest
 * ```
 * エラーが発生してしまうので fetch を使って実装
 */
const listReleaseAssets = async (parameter: {
  githubRepository: string;
  releaseId: number;
  githubToken: string;
}): Promise<
  ReadonlyArray<{ readonly id: number; readonly name: string }>
> => {
  return await (await ky.get(
    `https://api.github.com/repos/${parameter.githubRepository}/releases/${parameter.releaseId}/assets`,
    {
      headers: {
        Authorization: `Bearer ${parameter.githubToken}`,
        Accept: "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
      },
    },
  )).json();
};

/**
 * https://docs.github.com/ja/rest/releases/assets?apiVersion=2022-11-28#delete-a-release-asset
 * `@octokit/core` を使うと
 * ```txt
 * Uncaught (in promise) HttpError: Not Found - https://docs.github.com/rest
 * ```
 * エラーが発生してしまうので fetch を使って実装
 */
const deleteReleaseAsset = async (parameter: {
  readonly githubRepository: string;
  readonly githubToken: string;
  readonly assetId: number;
}): Promise<void> => {
  const response = await ky.delete(
    `https://api.github.com/repos/${parameter.githubRepository}/releases/assets/${parameter.assetId}`,
    {
      headers: {
        Authorization: `Bearer ${parameter.githubToken}`,
        Accept: "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
      },
    },
  );
  const text = await response.text();
  console.log(text);
};

/**
 * https://docs.github.com/ja/rest/releases/assets?apiVersion=2022-11-28#upload-a-release-asset
 * `@octokit/core` を使うと
 * ```txt
 * Uncaught (in promise) HttpError: Not Found - https://docs.github.com/rest
 * ```
 * エラーが発生してしまうので fetch を使って実装
 */
const uploadReleaseAsset = async (parameter: {
  readonly githubRepository: string;
  readonly githubToken: string;
  readonly name: string;
  readonly releaseId: number;
  readonly body: BodyInit;
}): Promise<void> => {
  const response = await ky.post(
    `https://uploads.github.com/repos/${parameter.githubRepository}/releases/${parameter.releaseId}/assets`,
    {
      searchParams: {
        name: parameter.name,
      },
      headers: {
        Authorization: `Bearer ${parameter.githubToken}`,
        Accept: "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "Content-Type": "application/octet-stream",
      },
      body: parameter.body,
    },
  );
  if (!response.ok) {
    throw new Error(await response.text());
  }
};

const isDirectory = async (path: string): Promise<boolean> => {
  const fileName = parse(path).base;
  for await (const file of Deno.readDir(join(path, ".."))) {
    if (file.name === fileName) {
      return file.isDirectory;
    }
  }
  throw new Error(`File or Directory not found: ${path}`);
};

const getFileContentOrZippedDir = async (
  path: string,
): Promise<Uint8Array> => {
  if (await isDirectory(path)) {
    const output = new Uint8ArrayWriter();
    const writer = new ZipWriter(output);
    writer.add("dummy", new Uint8ArrayReader(new Uint8Array([1, 2, 3])), {
      directory: true,
    });
    // for await (const entry of walk(path)) {
    //   console.log(entry.path, entry.name, entry.isDirectory);
    //   if (entry.isDirectory) {
    //     writer.add(entry.path, undefined, {
    //       directory: true,
    //     });
    //   } else {
    //     writer.add(
    //       entry.path,
    //       (await Deno.open(new URL(entry.path, path))).readable,
    //     );
    //   }
    // }
    writer.close();
    return await output.getData();
  }
  return await Deno.readFile(path);
};

await new Command()
  .option(
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
  ).option(
    "--githubToken=<value>",
    "",
    { required: true },
  ).env(
    "GITHUB_REPOSITORY=<value>",
    "",
    { required: true },
  )
  .action(
    async (
      {
        githubToken,
        githubRepository,
        releaseId,
        name,
        path,
      },
    ) => {
      const assets = await listReleaseAssets({
        githubRepository,
        releaseId,
        githubToken,
      });
      const asset = assets.find((asset) => asset.name === name);
      if (asset !== undefined) {
        await deleteReleaseAsset(
          {
            assetId: asset.id,
            githubRepository,
            githubToken,
          },
        );
      }
      await uploadReleaseAsset({
        githubRepository,
        releaseId,
        githubToken,
        name,
        body: await getFileContentOrZippedDir(fromFileUrl(path)),
      });
    },
  ).parse();

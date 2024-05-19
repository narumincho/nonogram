import { Command } from "jsr:@cliffy/command@1.0.0-rc.4";
import { join, parse } from "jsr:@std/path";
import { walk } from "jsr:@std/fs";
import { Uint8ArrayWriter, ZipWriter } from "jsr:@zip-js/zip-js";
// import ky from 'https://esm.sh/ky';

/**
 * https://docs.github.com/ja/rest/releases/assets?apiVersion=2022-11-28#list-release-assets
 *
 * Deno で `@octokit/core` を使うと
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
  return await (await fetch(
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
 * Deno で `@octokit/core` を使うと
 * ```txt
 * Uncaught (in promise) HttpError: Not Found - https://docs.github.com/rest
 * ```
 * エラーが発生してしまうので fetch を使って実装
 */
const deleteReleaseAsset = async (parameter: {
  readonly githubRepository: string;
  readonly githubToken: string;
  readonly assetId: number;
}): Promise<
  ReadonlyArray<{ readonly id: number; readonly name: string }>
> => {
  return await (await fetch(
    `https://api.github.com/repos/${parameter.githubRepository}/releases/assets/${parameter.assetId}`,
    {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${parameter.githubToken}`,
        Accept: "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
      },
    },
  )).json();
};

/**
 * https://docs.github.com/ja/rest/releases/assets?apiVersion=2022-11-28#upload-a-release-asset
 * Deno で `@octokit/core` を使うと
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
  readonly contentType: string;
  readonly body: BodyInit;
}): Promise<void> => {
  const url = new URL(
    `https://uploads.github.com/repos/${parameter.githubRepository}/releases/${parameter.releaseId}/assets`,
  );
  url.searchParams.set("name", parameter.name);
  const response = await fetch(
    url,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${parameter.githubToken}`,
        Accept: "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "Content-Type": parameter.contentType,
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
): Promise<ReadableStream<Uint8Array>> => {
  if (await isDirectory(path)) {
    const output = new TransformStream<Uint8Array, Uint8Array>();
    const writer = new ZipWriter(output.writable);
    for await (const entry of walk(path)) {
      console.log(entry.path, entry.name, entry.isDirectory);
      if (entry.isDirectory) {
        writer.add(entry.path, undefined, {
          directory: true,
        });
      } else {
        writer.add(entry.path, (await Deno.open(entry.path)).readable);
      }
    }
    writer.close();
    return output.readable;
  }
  return (await Deno.open(path)).readable;
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
      const zipBinaryWriter = new Uint8ArrayWriter();
      await zipBinaryWriter.init?.();
      (await getFileContentOrZippedDir(path)).pipeTo(zipBinaryWriter.writable);
      await uploadReleaseAsset({
        githubRepository,
        releaseId,
        githubToken,
        name,
        contentType: "application/zip",
        body: await zipBinaryWriter.getData(),
      });
    },
  ).parse();

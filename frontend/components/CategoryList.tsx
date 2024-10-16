import Link from "next/link";
import React from "react";
// import { Link } from "react-router-dom";
import { MdPlumbing } from "react-icons/md";

const categoryList = [1, 2, 3, 4, 5, 6, 7, 8, 9];
export const CategoryList = () => {
	return (
		<div className="mx-4 md:mx-24 lg:mx-52 grid grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4 ">
			{categoryList.length > 0
				? categoryList.map((item, index) => (
						<Link
							key={index}
							className="flex flex-col bg-purple-50 items-center gap-2 justify-center p-5 rounded-lg cursor-pointer hover:scale-110 transition-all ease-in-out"
							href={"/search/" + item}>
							<MdPlumbing className="text-4xl" />
							<span className="text-purple-500">plumber</span>
						</Link>
				  ))
				: [1, 2, 3, 4, 5, 6].map((item, index) => (
						<div
							key={index}
							className="h-[120px] w-[120px] bg-slate-200 animate-pulse rounded-lg"></div>
				  ))}
		</div>
	);
};
